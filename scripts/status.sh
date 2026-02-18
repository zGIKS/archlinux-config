#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOME_DIR="${HOME:-/home/giks}"

echo "Repo: $ROOT_DIR"
echo "Home: $HOME_DIR"
echo

mapfile -t modules < <(
  find "$ROOT_DIR" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort
)

for module in "${modules[@]}"; do
  case "$module" in
    .git|packages|scripts) continue ;;
  esac

  echo "[$module]"
  while IFS= read -r -d '' src; do
    rel="${src#$ROOT_DIR/$module/}"
    dst="$HOME_DIR/$rel"
    if [[ -e "$dst" ]]; then
      target="$(readlink -f "$dst" || true)"
      if [[ "$target" == "$src" ]]; then
        echo "OK   $dst -> $src"
      else
        echo "WARN $dst -> $target (esperado: $src)"
      fi
    else
      echo "MISS $dst"
    fi
  done < <(find "$ROOT_DIR/$module" \( -type f -o -type l \) -print0)
  echo
done
