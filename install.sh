#!/usr/bin/env bash
# Link this repo into $HOME. Safe to re-run: correct links are left alone,
# anything else in the way is moved aside to <name>.backup-<timestamp>.
#
#   ./install.sh            do it
#   ./install.sh --dry-run  only print what would change
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=0
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=1
STAMP="$(date +%Y%m%d-%H%M%S)"

run() {
  if (( DRY_RUN )); then
    echo "  would run: $*"
  else
    "$@"
  fi
}

# link <repo path> <destination>
link() {
  local src="$REPO/$1" dest="$2"

  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
    echo "ok       $dest"
    return
  fi

  if [[ -e "$dest" || -L "$dest" ]]; then
    echo "backup   $dest -> $dest.backup-$STAMP"
    run mv "$dest" "$dest.backup-$STAMP"
  fi

  echo "link     $dest -> $src"
  run mkdir -p "$(dirname "$dest")"
  # -n: never follow an existing link to a directory (that's how a stray
  # dot_config/cava/cava -> cava once got created)
  run ln -sn "$src" "$dest"
}

# Every tool under dot_config/ goes to ~/.config/<tool>
for dir in "$REPO"/dot_config/*/; do
  name="$(basename "$dir")"
  link "dot_config/$name" "$HOME/.config/$name"
done

link dot_gitconfig "$HOME/.gitconfig"

# Legacy: tmux is only kept as a fallback (tcode/twh/tnocode)
link dot_tmux "$HOME/.tmux"
link dot_tmux.conf "$HOME/.tmux.conf"

# Per-machine files that are gitignored but must exist, because niri
# refuses to load a config whose `include` points at a missing file.
# DMS fills them in once it runs; outputs.kdl is set up per machine.
for f in dot_config/niri/dms/outputs.kdl dot_config/niri/dms/colors.kdl; do
  if [[ ! -e "$REPO/$f" ]]; then
    echo "create   $REPO/$f (empty, per-machine)"
    run touch "$REPO/$f"
  fi
done

# Shell functions and aliases are sourced from ~/.zshrc, not linked
ZSHRC="$HOME/.zshrc"
for f in zsh_functions.zsh zsh_aliases.zsh; do
  line="source $REPO/$f"
  if [[ -f "$ZSHRC" ]] && grep -qF "/$f" "$ZSHRC"; then
    echo "ok       $ZSHRC sources $f"
  else
    echo "append   $ZSHRC: $line"
    (( DRY_RUN )) || echo "$line" >> "$ZSHRC"
  fi
done
