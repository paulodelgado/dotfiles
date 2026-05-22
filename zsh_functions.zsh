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

  kitten @ set-tab-title "$CURRENT_PROJECT"

  # 3. Attach
  tmux attach-session -t "$PROJECT_NAME"
}

wh() {
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
