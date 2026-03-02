#!/usr/bin/env bash
set -euo pipefail

[[ "${BASH_SOURCE[0]}" != "$0" ]] || {
  echo "Do not run directly: use ./install.sh"
  exit 1
}

configure_login_shell() {
  local fish_path current_shell

  if ! command -v fish >/dev/null 2>&1; then
    echo "fish is not installed; skipping login shell configuration."
    return 0
  fi

  fish_path="$(command -v fish)"
  current_shell="${SHELL:-}"

  if [[ "$current_shell" == "$fish_path" ]]; then
    echo "Login shell already set to fish ($fish_path)."
    return 0
  fi

  if [[ ! -t 0 ]]; then
    echo "fish installed at $fish_path."
    echo "Set it as login shell manually: chsh -s $fish_path"
    return 0
  fi

  echo "Setting login shell to fish ($fish_path)..."
  if chsh -s "$fish_path"; then
    echo "Login shell updated to fish."
  else
    echo "Could not change login shell automatically."
    echo "Run manually: chsh -s $fish_path"
  fi
}
