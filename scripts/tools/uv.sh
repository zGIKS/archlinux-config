#!/usr/bin/env bash
set -euo pipefail

[[ "${BASH_SOURCE[0]}" != "$0" ]] || {
  echo "Do not run directly: use ./install.sh"
  exit 1
}

install_uv_tools_from_manifest() {
  local -a tools=("$@")
  if [[ ${#tools[@]} -eq 0 ]]; then
    return 0
  fi
  if ! command -v uv >/dev/null 2>&1; then
    echo "uv not available; skipping uv tools."
    return 0
  fi

  echo "Installing uv tools: ${tools[*]}"
  local item
  for item in "${tools[@]}"; do
    uv tool install "$item"
  done
}
