#!/usr/bin/env bash
set -euo pipefail

[[ "${BASH_SOURCE[0]}" != "$0" ]] || {
  echo "Do not run directly: use ./install.sh"
  exit 1
}

read_non_comment_lines() {
  local file="$1"
  if [[ ! -f "$file" ]]; then
    return 0
  fi
  grep -Ev '^\s*(#|$)' "$file" || true
}
