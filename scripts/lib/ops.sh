#!/usr/bin/env bash
set -euo pipefail

[[ "${BASH_SOURCE[0]}" != "$0" ]] || {
  echo "No ejecutar directamente: usar ./install.sh"
  exit 1
}

do_link() {
  "$ROOT_DIR/scripts/link.sh"
}

do_status() {
  "$ROOT_DIR/scripts/status.sh"
}

do_check() {
  "$ROOT_DIR/scripts/check-path.sh"
}
