#!/usr/bin/env bash
set -euo pipefail

[[ "${BASH_SOURCE[0]}" != "$0" ]] || {
  echo "Do not run directly: use ./install.sh"
  exit 1
}

configure_libclang_for_bindgen() {
  if [[ -n "${LIBCLANG_PATH:-}" ]]; then
    printf '%s\n' "$LIBCLANG_PATH"
    return 0
  fi

  local -a candidates=(
    /usr/lib
    /usr/lib64
    /usr/lib/llvm*/lib
  )
  local dir
  for dir in "${candidates[@]}"; do
    if compgen -G "$dir/libclang.so*" >/dev/null; then
      printf '%s\n' "$dir"
      return 0
    fi
  done

  return 1
}

install_rustup_toolchains_from_manifest() {
  local -a toolchains=("$@")
  if [[ ${#toolchains[@]} -eq 0 ]]; then
    return 0
  fi
  if ! command -v rustup >/dev/null 2>&1; then
    echo "rustup not available; skipping rustup toolchains."
    return 0
  fi

  echo "Installing rustup toolchains: ${toolchains[*]}"
  local item
  for item in "${toolchains[@]}"; do
    rustup toolchain install "$item"
  done
}

install_rustup_components_from_manifest() {
  local -a components=("$@")
  if [[ ${#components[@]} -eq 0 ]]; then
    return 0
  fi
  if ! command -v rustup >/dev/null 2>&1; then
    echo "rustup not available; skipping rustup components."
    return 0
  fi

  echo "Installing rustup components: ${components[*]}"
  local item
  for item in "${components[@]}"; do
    if [[ "$item" == *"@"* ]]; then
      rustup component add "${item%@*}" --toolchain "${item#*@}"
    else
      rustup component add "$item"
    fi
  done
}

install_rustup_targets_from_manifest() {
  local -a targets=("$@")
  if [[ ${#targets[@]} -eq 0 ]]; then
    return 0
  fi
  if ! command -v rustup >/dev/null 2>&1; then
    echo "rustup not available; skipping rustup targets."
    return 0
  fi

  echo "Installing rustup targets: ${targets[*]}"
  local item
  for item in "${targets[@]}"; do
    if [[ "$item" == *"@"* ]]; then
      rustup target add "${item%@*}" --toolchain "${item#*@}"
    else
      rustup target add "$item"
    fi
  done
}

install_cargo_packages_from_manifest() {
  local -a packages=("$@")
  if [[ ${#packages[@]} -eq 0 ]]; then
    return 0
  fi
  if ! command -v cargo >/dev/null 2>&1; then
    echo "cargo not available; skipping cargo packages."
    return 0
  fi

  echo "Installing cargo packages: ${packages[*]}"
  local libclang_path
  if libclang_path="$(configure_libclang_for_bindgen)"; then
    export LIBCLANG_PATH="$libclang_path"
    echo "Using LIBCLANG_PATH=$LIBCLANG_PATH"
  else
    echo "Warning: libclang not detected. Install clang/llvm or set LIBCLANG_PATH."
  fi
  local item
  for item in "${packages[@]}"; do
    if [[ "$item" == *"@"* ]]; then
      if [[ -n "${LIBCLANG_PATH:-}" ]]; then
        LIBCLANG_PATH="$LIBCLANG_PATH" cargo install "${item%@*}" --version "${item#*@}" --locked
      else
        cargo install "${item%@*}" --version "${item#*@}" --locked
      fi
    else
      if [[ -n "${LIBCLANG_PATH:-}" ]]; then
        LIBCLANG_PATH="$LIBCLANG_PATH" cargo install "$item" --locked
      else
        cargo install "$item" --locked
      fi
    fi
  done
}
