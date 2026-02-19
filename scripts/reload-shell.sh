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
    echo "Shell no soportada automaticamente: $current_shell"
    echo "Abre una nueva terminal o ejecuta: exec fish | exec bash -l | exec zsh -l"
    exit 1
    ;;
esac
