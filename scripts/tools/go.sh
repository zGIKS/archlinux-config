#!/usr/bin/env bash
set -euo pipefail

[[ "${BASH_SOURCE[0]}" != "$0" ]] || {
  echo "Do not run directly: use ./install.sh"
  exit 1
}

install_go_packages_from_manifest() {
  local -a packages=("$@")
  if [[ ${#packages[@]} -eq 0 ]]; then
    return 0
  fi
  if ! command -v go >/dev/null 2>&1; then
    echo "go not available; skipping go packages."
    return 0
  fi

  echo "Installing go packages: ${packages[*]}"
  local item
  for item in "${packages[@]}"; do
    go install "$item"
  done
}
