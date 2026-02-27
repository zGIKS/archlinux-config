#!/usr/bin/env bash
set -euo pipefail

[[ "${BASH_SOURCE[0]}" != "$0" ]] || {
  echo "Do not run directly: use ./install.sh"
  exit 1
}

install_volta_packages_from_manifest() {
  local -a vpkg=("$@")
  if [[ ${#vpkg[@]} -eq 0 ]]; then
    return 0
  fi
  if ! command -v volta >/dev/null 2>&1; then
    echo "volta not available; skipping Node CLI installation."
    return 0
  fi

  echo "Installing with volta: ${vpkg[*]}"
  volta install "${vpkg[@]}"
}
