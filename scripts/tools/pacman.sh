#!/usr/bin/env bash
set -euo pipefail

[[ "${BASH_SOURCE[0]}" != "$0" ]] || {
  echo "Do not run directly: use ./install.sh"
  exit 1
}

install_pacman_language_packages() {
  local -a pkgs=("$@")
  if [[ ${#pkgs[@]} -eq 0 ]]; then
    return 0
  fi

  if ! command -v pacman >/dev/null 2>&1; then
    echo "pacman not available; skipping language package installation."
    return 0
  fi

  local -a available=()
  local -a missing=()
  local pkg
  for pkg in "${pkgs[@]}"; do
    if pacman -Si "$pkg" >/dev/null 2>&1; then
      available+=("$pkg")
    else
      missing+=("$pkg")
    fi
  done

  if [[ ${#available[@]} -gt 0 ]]; then
    echo "Installing language packages with pacman: ${available[*]}"
    sudo pacman -S --needed "${available[@]}"
  fi

  if [[ ${#missing[@]} -gt 0 ]]; then
    if command -v yay >/dev/null 2>&1; then
      echo "Installing language packages with yay: ${missing[*]}"
      yay -S --needed "${missing[@]}"
    else
      echo "Missing language packages and yay is not installed: ${missing[*]}"
    fi
  fi
}
