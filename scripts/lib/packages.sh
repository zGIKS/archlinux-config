#!/usr/bin/env bash
set -euo pipefail

[[ "${BASH_SOURCE[0]}" != "$0" ]] || {
  echo "Do not run directly: use ./install.sh"
  exit 1
}

install_packages() {
  if ! command -v pacman >/dev/null 2>&1; then
    echo "pacman not available; skipping package installation."
    return 0
  fi

  if [[ ! -f "$PACKAGES_FILE" ]]; then
    echo "No $PACKAGES_FILE exists; skipping package installation."
    return 0
  fi

  mapfile -t pkgs < <(grep -Ev '^\s*(#|$)' "$PACKAGES_FILE")
  if [[ ${#pkgs[@]} -eq 0 ]]; then
    echo "No packages in $PACKAGES_FILE."
    return 0
  fi

  available=()
  missing=()
  for pkg in "${pkgs[@]}"; do
    if pacman -Si "$pkg" >/dev/null 2>&1; then
      available+=("$pkg")
    else
      missing+=("$pkg")
    fi
  done

  if [[ ${#missing[@]} -gt 0 ]]; then
    echo "Packages not found in pacman repos (skipped): ${missing[*]}"
  fi

  if [[ ${#available[@]} -eq 0 ]]; then
    echo "No packages available to install via pacman."
  else
    echo "Installing with pacman: ${available[*]}"
    sudo pacman -S --needed "${available[@]}"
  fi

  if [[ ${#missing[@]} -gt 0 ]]; then
    if command -v yay >/dev/null 2>&1; then
      echo "Installing with yay (not found in pacman): ${missing[*]}"
      yay -S --needed "${missing[@]}"
    else
      echo "Missing AUR packages and yay is not installed: ${missing[*]}"
    fi
  fi
}
