#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOME_DIR="${HOME:-/home/giks}"

is_package_dir() {
  local name="$1"
  [[ "$name" != ".git" && "$name" != "packages" && "$name" != "scripts" ]]
}

mapfile -t modules < <(
  find "$ROOT_DIR" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort
)

if [[ ${#modules[@]} -eq 0 ]]; then
  echo "No se encontraron modulos de dotfiles."
  exit 0
fi

filtered=()
for m in "${modules[@]}"; do
  if is_package_dir "$m"; then
    filtered+=("$m")
  fi
done

if [[ ${#filtered[@]} -eq 0 ]]; then
  echo "No hay modulos validos para enlazar."
  exit 0
fi

if command -v stow >/dev/null 2>&1; then
  echo "Usando stow para enlazar: ${filtered[*]}"
  (
    cd "$ROOT_DIR"
    stow --target "$HOME_DIR" --restow "${filtered[@]}"
  )
  echo "Enlaces creados con stow."
  exit 0
fi

echo "stow no instalado; usando fallback manual con symlinks."
for module in "${filtered[@]}"; do
  while IFS= read -r -d '' src; do
    rel="${src#$ROOT_DIR/$module/}"
    dst="$HOME_DIR/$rel"
    dst_dir="$(dirname "$dst")"
    mkdir -p "$dst_dir"
    ln -sfn "$src" "$dst"
    echo "link: $dst -> $src"
  done < <(find "$ROOT_DIR/$module" \( -type f -o -type l \) -print0)
done

echo "Enlaces creados con fallback manual."
