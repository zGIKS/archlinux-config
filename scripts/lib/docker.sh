#!/usr/bin/env bash
set -euo pipefail

[[ "${BASH_SOURCE[0]}" != "$0" ]] || {
  echo "No ejecutar directamente: usar ./install.sh"
  exit 1
}

configure_docker() {
  if ! command -v docker >/dev/null 2>&1; then
    echo "docker no disponible; se omite configuracion de servicio/grupo."
    return 0
  fi

  if command -v systemctl >/dev/null 2>&1 && [[ -d /run/systemd/system ]]; then
    if systemctl is-enabled docker >/dev/null 2>&1; then
      if ! systemctl is-active docker >/dev/null 2>&1; then
        echo "Iniciando servicio docker..."
        sudo systemctl start docker
      fi
    else
      echo "Habilitando e iniciando servicio docker..."
      sudo systemctl enable --now docker
    fi
  else
    echo "systemd no detectado; se omite gestion de docker.service."
  fi

  if id -nG "$USER" | tr ' ' '\n' | grep -qx docker; then
    echo "Usuario '$USER' ya pertenece al grupo docker."
  else
    echo "Agregando usuario '$USER' al grupo docker..."
    sudo usermod -aG docker "$USER"
    echo "IMPORTANTE: cierra y abre sesion para aplicar el grupo docker."
  fi

  if docker compose version >/dev/null 2>&1; then
    echo "docker compose (v2) disponible."
  elif command -v docker-compose >/dev/null 2>&1; then
    echo "docker-compose disponible, pero se recomienda usar 'docker compose'."
  else
    echo "No se detecta Docker Compose; revisa paquetes docker-compose/docker-compose-plugin."
  fi
}
