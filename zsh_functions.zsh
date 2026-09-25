# Open (or switch to) a herdr workspace for a project, attaching if needed.
# Usage: _herdr_open [--claude] <name> <path> <first-tab> [more tabs...]
# The first tab runs nvim (with --claude, plus `claude --continue` in a pane
# on the right); the rest are plain shells in <path>.
_herdr_open() {
  local with_claude=0
  [[ "$1" == --claude ]] && { with_claude=1; shift; }
  local name="$1" dir="$2" first_tab="$3"
  shift 3

  # Make sure the herdr server is up (the control API needs it)
  if ! herdr workspace list >/dev/null 2>&1; then
    herdr server >/dev/null 2>&1 &!
    local tries=0
    until herdr workspace list >/dev/null 2>&1; do
      (( ++tries > 50 )) && { echo "Error: herdr server did not start."; return 1; }
      sleep 0.1
    done
  fi

  # Find the project's workspace, or create it
  local ws_id=$(_herdr_workspace_id "$name")

  if [ -z "$ws_id" ]; then
    local created=$(herdr workspace create --cwd "$dir" --label "$name" --no-focus)
    ws_id=$(jq -r '.result.workspace.workspace_id' <<< "$created")
    local code_tab=$(jq -r '.result.tab.tab_id' <<< "$created")

    # First tab gets renamed and runs nvim
    herdr tab rename "$code_tab" "$first_tab" >/dev/null
    local nvim_pane=$(jq -r '.result.root_pane.pane_id' <<< "$created")
    herdr pane run "$nvim_pane" nvim >/dev/null

    # Optionally put Claude on the right, resuming the last conversation
    if (( with_claude )); then
      local claude_pane=$(herdr pane split "$nvim_pane" --direction right --cwd "$dir" --no-focus |
        jq -r '.result.pane.pane_id')
      herdr pane run "$claude_pane" "claude --continue" >/dev/null
    fi

    # Create remaining tabs in the project directory
    local tab
    for tab in "$@"; do
      herdr tab create --workspace "$ws_id" --cwd "$dir" --label "$tab" --no-focus >/dev/null
    done

    # Ensure we land on the first tab
    herdr tab focus "$code_tab" >/dev/null
  fi

  herdr workspace focus "$ws_id" >/dev/null

  # Attach (already inside herdr, the focus switch above is enough)
  if [[ "$HERDR_ENV" != 1 ]]; then
    kitten @ set-tab-title "$name"
    herdr
  fi
}

# Print the id of the herdr workspace labelled <name>, if any
_herdr_workspace_id() {
  herdr workspace list 2>/dev/null | jq -r --arg name "$1" \
    'first(.result.workspaces[] | select(.label == $name) | .workspace_id) // empty'
}

code() {
  # 1. Project selection logic
  if [ -z "$1" ]; then
    echo "Available projects:"
    local projects=($(ls -d "$WORK_DIR"/*/ 2>/dev/null | xargs -n 1 basename))
    select PROJECT_NAME in "${projects[@]}"; do
      [[ -n "$PROJECT_NAME" ]] && break
      echo "Invalid selection. Please try again."
    done
  else
    PROJECT_NAME="$1"
  fi

  PROJECT_PATH="$WORK_DIR/$PROJECT_NAME"

  if [ ! -d "$PROJECT_PATH" ]; then
    echo "Error: Directory $PROJECT_PATH does not exist."
    return 1
  fi

  cd "$PROJECT_PATH" || return

  _herdr_open --claude "$PROJECT_NAME" "$PROJECT_PATH" code git vox staging prod
}

tcode() {
  # 1. Project selection logic
  if [ -z "$1" ]; then
    echo "Available projects:"
    local projects=($(ls -d "$WORK_DIR"/*/ 2>/dev/null | xargs -n 1 basename))
    select PROJECT_NAME in "${projects[@]}"; do
      [[ -n "$PROJECT_NAME" ]] && break
      echo "Invalid selection. Please try again."
    done
  else
    PROJECT_NAME="$1"
  fi

  PROJECT_PATH="$WORK_DIR/$PROJECT_NAME"

  if [ ! -d "$PROJECT_PATH" ]; then
    echo "Error: Directory $PROJECT_PATH does not exist."
    return 1
  fi

  cd "$PROJECT_PATH" || return

  # 2. Check if the session exists
  tmux has-session -t "$PROJECT_NAME" 2>/dev/null

  if [ $? != 0 ]; then
    # Create session, name the first window 'code', and launch nvim
    # The -c flag ensures the session starts in the project directory
    tmux new-session -d -s "$PROJECT_NAME" -n 'code' -c "$PROJECT_PATH" 'nvim'

    # Create remaining windows, explicitly setting the start directory
    tmux new-window -t "$PROJECT_NAME" -n 'git' -c "$PROJECT_PATH"
    tmux new-window -t "$PROJECT_NAME" -n 'vox' -c "$PROJECT_PATH"
    tmux new-window -t "$PROJECT_NAME" -n 'staging' -c "$PROJECT_PATH"
    tmux new-window -t "$PROJECT_NAME" -n 'prod' -c "$PROJECT_PATH"

    # Ensure we are focused on the 'code' window where nvim is running
    tmux select-window -t "${PROJECT_NAME}:code"
  fi

  kitten @ set-tab-title "$PROJECT_NAME"

  # 3. Attach
  tmux attach-session -t "$PROJECT_NAME"
}

wh() {
  _herdr_open "${PWD##*/}" "$PWD" code git console
}

twh() {
  CURRENT_PROJECT=${PWD##*/}
  # echo $CURRENT_PROJECT
  # return
  # 2. Check if the session exists
  tmux has-session -t "$CURRENT_PROJECT" 2>/dev/null

  if [ $? != 0 ]; then
    # Create session, name the first window 'code', and launch nvim
    # The -c flag ensures the session starts in the project directory
    tmux new-session -d -s "$CURRENT_PROJECT" -n 'code' -c "$PWD" 'nvim'

    # Create remaining windows, explicitly setting the start directory
    tmux new-window -t "$CURRENT_PROJECT" -n 'git' -c "$PWD"
    tmux new-window -t "$CURRENT_PROJECT" -n 'console' -c "$PWD"

    # Ensure we are focused on the 'code' window where nvim is running
    tmux select-window -t "${CURRENT_PROJECT}:code"
  fi

  kitten @ set-tab-title "$CURRENT_PROJECT"

  # 3. Attach
  tmux attach-session -t "$CURRENT_PROJECT"

}

nocode() {
  # If no name is provided, use the herdr workspace we're running in
  local ws_id
  if [ -n "$1" ]; then
    ws_id=$(_herdr_workspace_id "$1")
  else
    ws_id="$HERDR_WORKSPACE_ID"
  fi

  if [ -n "$ws_id" ]; then
    local label=$(herdr workspace get "$ws_id" 2>/dev/null | jq -r '.result.workspace.label // empty')
    # Echo first: closing our own workspace kills this shell
    echo "Workspace '${label:-$ws_id}' terminated."
    herdr workspace close "$ws_id" >/dev/null
  elif [ -n "$1" ]; then
    echo "Error: No herdr workspace named '$1'."
  else
    echo "Error: Not in a herdr workspace and no name provided."
  fi
}

tnocode() {
  # If no name is provided, try to get the current tmux session name
  local session_name="${1:-$(tmux display-message -p '#S')}"

  if [ -n "$session_name" ]; then
    tmux kill-session -t "$session_name"
    echo "Session '$session_name' terminated."
  else
    echo "Error: Not in a tmux session or no session name provided."
  fi
}

# Clean up local git branches that don't have an active GitHub PR
prune_old_git_branches() {
  # Ensure we are actually inside a git repository
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Error: This is not a git repository."
    return 1
  fi

  echo "Checking local branches against GitHub open PRs..."
  echo "------------------------------------------------"

  for branch in $(git branch --format='%(refname:short)'); do
    # Protect core branches
    if [[ "$branch" == "main" || "$branch" == "master" || "$branch" == "staging" || "$branch" == "development" ]]; then
      continue
    fi

    # Check for OPEN PRs. If none are found, prompt for deletion.
    if ! gh pr list --head "$branch" --state open --json number --jq '.[0].number' | grep -q '[0-9]'; then
      # Prompt the user interactively
      read -k 1 "response?No active PR found for '$branch'. Delete local branch? [y/N]: "
      echo "" # Move to a new line after the single-key press

      case "$response" in
        [yY]) 
          git branch -D "$branch"
          ;;
        *)
          echo "Skipped: $branch"
          ;;
      esac
    fi
  done

  echo "------------------------------------------------"
  echo "Branch pruning complete!"
}
