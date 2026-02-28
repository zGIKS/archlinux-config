#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOME_DIR="${HOME:-/home/giks}"

is_package_dir() {
  local name="$1"
  [[ "$name" != ".git" && "$name" != "packages" && "$name" != "scripts" ]]
}

mapfile -t modules < <(
  find "$ROOT_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort
)

if [[ ${#modules[@]} -eq 0 ]]; then
  echo "No dotfiles modules found."
  exit 0
fi

filtered=()
for m in "${modules[@]}"; do
  if is_package_dir "$m"; then
    filtered+=("$m")
  fi
done

if [[ ${#filtered[@]} -eq 0 ]]; then
  echo "No valid modules to link."
  exit 0
fi

if command -v stow >/dev/null 2>&1; then
  echo "Using stow to link: ${filtered[*]}"
  (
    cd "$ROOT_DIR"
    stow --target "$HOME_DIR" --restow "${filtered[@]}"
  )
  echo "Links created with stow."
  exit 0
fi

echo "stow not installed; using manual symlink fallback."

backup_destination() {
  local dst="$1"
  local ts backup idx
  ts="$(date +%Y%m%d%H%M%S)"
  backup="${dst}.bak.${ts}"
  idx=1
  while [[ -e "$backup" || -L "$backup" ]]; do
    backup="${dst}.bak.${ts}.${idx}"
    idx=$((idx + 1))
  done
  mv "$dst" "$backup"
  echo "backup: $dst -> $backup"
}

for module in "${filtered[@]}"; do
  while IFS= read -r -d '' src; do
    rel="${src#$ROOT_DIR/$module/}"
    dst="$HOME_DIR/$rel"
    dst_dir="$(dirname "$dst")"
    mkdir -p "$dst_dir"
    if [[ -e "$dst" || -L "$dst" ]]; then
      resolved="$(readlink -f "$dst" || true)"
      if [[ "$resolved" == "$src" ]]; then
        echo "skip: $dst already points to $src"
        continue
      fi
      backup_destination "$dst"
    fi
    ln -s "$src" "$dst"
    echo "link: $dst -> $src"
  done < <(find "$ROOT_DIR/$module" \( -type f -o -type l \) -print0)
done

echo "Links created with manual fallback."
