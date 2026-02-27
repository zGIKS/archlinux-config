#!/usr/bin/env bash
set -euo pipefail

[[ "${BASH_SOURCE[0]}" != "$0" ]] || {
  echo "Do not run directly: use ./install.sh"
  exit 1
}

configure_docker() {
  if ! command -v docker >/dev/null 2>&1; then
    echo "docker not available; skipping service/group configuration."
    return 0
  fi

  if command -v systemctl >/dev/null 2>&1 && [[ -d /run/systemd/system ]]; then
    if systemctl is-enabled docker >/dev/null 2>&1; then
      if ! systemctl is-active docker >/dev/null 2>&1; then
        echo "Starting docker service..."
        sudo systemctl start docker
      fi
    else
      echo "Enabling and starting docker service..."
      sudo systemctl enable --now docker
    fi
  else
    echo "systemd not detected; skipping docker.service management."
  fi

  if id -nG "$USER" | tr ' ' '\n' | grep -qx docker; then
    echo "User '$USER' already belongs to the docker group."
  else
    echo "Adding user '$USER' to the docker group..."
    sudo usermod -aG docker "$USER"
    echo "IMPORTANT: Log out and back in to apply docker group changes."
  fi

  if docker compose version >/dev/null 2>&1; then
    echo "docker compose (v2) available."
  elif command -v docker-compose >/dev/null 2>&1; then
    echo "docker-compose available, but using 'docker compose' is recommended."
  else
    echo "Docker Compose not detected; check docker-compose/docker-compose-plugin packages."
  fi
}
