#!/usr/bin/env bash
set -euo pipefail

[[ "${BASH_SOURCE[0]}" != "$0" ]] || {
  echo "Do not run directly: use ./install.sh"
  exit 1
}

install_language_tools() {
  if [[ ! -f "$LANGUAGE_TOOLS_FILE" ]]; then
    echo "No $LANGUAGE_TOOLS_FILE exists; skipping language tools."
    return 0
  fi

  local -a pacman_pkgs=()
  local -a rustup_toolchains=()
  local -a rustup_components=()
  local -a rustup_targets=()
  local -a cargo_packages=()
  local -a go_packages=()
  local -a uv_tools=()
  local -a volta_packages=()
  local line manager value

  while IFS= read -r line; do
    [[ "$line" == *"|"* ]] || {
      echo "Skipping invalid language entry (missing '|'): $line"
      continue
    }
    manager="${line%%|*}"
    value="${line#*|}"
    if [[ -z "$manager" || -z "$value" ]]; then
      echo "Skipping invalid language entry: $line"
      continue
    fi

    case "$manager" in
      pacman) pacman_pkgs+=("$value") ;;
      rustup-toolchain) rustup_toolchains+=("$value") ;;
      rustup-component) rustup_components+=("$value") ;;
      rustup-target) rustup_targets+=("$value") ;;
      cargo) cargo_packages+=("$value") ;;
      go) go_packages+=("$value") ;;
      uv-tool) uv_tools+=("$value") ;;
      volta) volta_packages+=("$value") ;;
      *)
        echo "Unknown language manager '$manager' (entry skipped): $line"
        ;;
    esac
  done < <(read_non_comment_lines "$LANGUAGE_TOOLS_FILE")

  if [[ ${#pacman_pkgs[@]} -eq 0 && ${#rustup_toolchains[@]} -eq 0 && ${#rustup_components[@]} -eq 0 && \
        ${#rustup_targets[@]} -eq 0 && ${#cargo_packages[@]} -eq 0 && ${#go_packages[@]} -eq 0 && \
        ${#uv_tools[@]} -eq 0 && ${#volta_packages[@]} -eq 0 ]]; then
    echo "No entries in $LANGUAGE_TOOLS_FILE."
    return 0
  fi

  install_pacman_language_packages "${pacman_pkgs[@]}"
  install_rustup_toolchains_from_manifest "${rustup_toolchains[@]}"
  install_rustup_components_from_manifest "${rustup_components[@]}"
  install_rustup_targets_from_manifest "${rustup_targets[@]}"
  install_cargo_packages_from_manifest "${cargo_packages[@]}"
  install_go_packages_from_manifest "${go_packages[@]}"
  install_uv_tools_from_manifest "${uv_tools[@]}"
  install_volta_packages_from_manifest "${volta_packages[@]}"
}
