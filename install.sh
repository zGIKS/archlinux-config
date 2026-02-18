#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES_FILE="$ROOT_DIR/packages/arch-cli.txt"

show_help() {
  cat <<'EOF'
Usage: ./install.sh [--packages] [--link] [--status] [--help]

Options:
  --packages  Instala paquetes CLI de packages/arch-cli.txt.
  --link      Crea/enlaza dotfiles en $HOME.
  --status    Muestra estado de enlaces.
  --help      Muestra esta ayuda.

Si no se pasa ninguna opcion, ejecuta: --link
EOF
}

install_packages() {
  if ! command -v pacman >/dev/null 2>&1; then
    echo "pacman no disponible; se omite instalacion de paquetes."
    return 0
  fi

  if [[ ! -f "$PACKAGES_FILE" ]]; then
    echo "No existe $PACKAGES_FILE; se omite instalacion de paquetes."
    return 0
  fi

  mapfile -t pkgs < <(grep -Ev '^\s*(#|$)' "$PACKAGES_FILE")
  if [[ ${#pkgs[@]} -eq 0 ]]; then
    echo "No hay paquetes en $PACKAGES_FILE."
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
    echo "Paquetes no encontrados en repos pacman (omitidos): ${missing[*]}"
  fi

  if [[ ${#available[@]} -eq 0 ]]; then
    echo "No hay paquetes disponibles para instalar desde pacman."
  else
    echo "Instalando con pacman: ${available[*]}"
    sudo pacman -S --needed "${available[@]}"
  fi

  if [[ ${#missing[@]} -gt 0 ]]; then
    if command -v yay >/dev/null 2>&1; then
      echo "Instalando con yay (no encontrados en pacman): ${missing[*]}"
      yay -S --needed "${missing[@]}"
    else
      echo "Faltan paquetes de AUR y yay no esta instalado: ${missing[*]}"
    fi
  fi
}

do_link() {
  "$ROOT_DIR/scripts/link.sh"
}

do_status() {
  "$ROOT_DIR/scripts/status.sh"
}

run_packages=false
run_link=false
run_status=false

if [[ $# -eq 0 ]]; then
  run_link=true
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --packages)
      run_packages=true
      shift
      ;;
    --link)
      run_link=true
      shift
      ;;
    --status)
      run_status=true
      shift
      ;;
    --help|-h)
      show_help
      exit 0
      ;;
    *)
      echo "Opcion no valida: $1"
      show_help
      exit 1
      ;;
  esac
done

$run_packages && install_packages
$run_link && do_link
$run_status && do_status

echo "Listo."
