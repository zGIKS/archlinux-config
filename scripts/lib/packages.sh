#!/usr/bin/env bash
set -euo pipefail

[[ "${BASH_SOURCE[0]}" != "$0" ]] || {
  echo "No ejecutar directamente: usar ./install.sh"
  exit 1
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
