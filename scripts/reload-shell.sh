#!/usr/bin/env bash
set -euo pipefail

current_shell="${SHELL##*/}"

case "$current_shell" in
  fish)
    exec fish
    ;;
  bash)
    exec bash -l
    ;;
  zsh)
    exec zsh -l
    ;;
  *)
    echo "Shell not automatically supported: $current_shell"
    echo "Open a new terminal or run: exec fish | exec bash -l | exec zsh -l"
    exit 1
    ;;
esac
