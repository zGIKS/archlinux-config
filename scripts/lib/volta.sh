#!/usr/bin/env bash
set -euo pipefail

[[ "${BASH_SOURCE[0]}" != "$0" ]] || {
  echo "Do not run directly: use ./install.sh"
  exit 1
}

install_volta_packages() {
  if ! command -v volta >/dev/null 2>&1; then
    echo "volta not available; skipping Node CLI installation."
    return 0
  fi

  if [[ ! -f "$VOLTA_PACKAGES_FILE" ]]; then
    echo "No $VOLTA_PACKAGES_FILE exists; skipping Node CLI installation."
    return 0
  fi

  mapfile -t vpkg < <(grep -Ev '^\s*(#|$)' "$VOLTA_PACKAGES_FILE")
  if [[ ${#vpkg[@]} -eq 0 ]]; then
    echo "No packages in $VOLTA_PACKAGES_FILE."
    return 0
  fi

  echo "Installing with volta: ${vpkg[*]}"
  volta install "${vpkg[@]}"
}
