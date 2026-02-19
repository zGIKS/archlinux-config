#!/usr/bin/env bash
set -euo pipefail

[[ "${BASH_SOURCE[0]}" != "$0" ]] || {
  echo "No ejecutar directamente: usar ./install.sh"
  exit 1
}

install_volta_packages() {
  if ! command -v volta >/dev/null 2>&1; then
    echo "volta no disponible; se omite instalacion de CLIs Node."
    return 0
  fi

  if [[ ! -f "$VOLTA_PACKAGES_FILE" ]]; then
    echo "No existe $VOLTA_PACKAGES_FILE; se omite instalacion de CLIs Node."
    return 0
  fi

  mapfile -t vpkg < <(grep -Ev '^\s*(#|$)' "$VOLTA_PACKAGES_FILE")
  if [[ ${#vpkg[@]} -eq 0 ]]; then
    echo "No hay paquetes en $VOLTA_PACKAGES_FILE."
    return 0
  fi

  echo "Instalando con volta: ${vpkg[*]}"
  volta install "${vpkg[@]}"
}
