#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES_FILE="$ROOT_DIR/packages/arch-cli.txt"
LANGUAGE_TOOLS_FILE="$ROOT_DIR/packages/languages-tools.txt"
LIB_DIR="$ROOT_DIR/scripts/lib"
TOOLS_DIR="$ROOT_DIR/scripts/tools"

source "$LIB_DIR/packages.sh"
source "$LIB_DIR/ops.sh"
source "$TOOLS_DIR/common.sh"
source "$TOOLS_DIR/docker.sh"
source "$TOOLS_DIR/pacman.sh"
source "$TOOLS_DIR/shell.sh"
source "$TOOLS_DIR/rust.sh"
source "$TOOLS_DIR/go.sh"
source "$TOOLS_DIR/uv.sh"
source "$TOOLS_DIR/volta.sh"
source "$TOOLS_DIR/languages.sh"

show_help() {
  cat <<'EOF'
Usage: ./install.sh [--packages] [--link] [--status] [--check] [--help]

Options:
  --packages  Installs CLI packages and language tooling from packages/*.txt.
  --link      Creates/links dotfiles in $HOME.
  --status    Shows link status.
  --check     Verifies PATH order/status for key tools.
  --help      Shows this help message.

If no options are passed, it runs: --link
EOF
}

run_packages=false
run_link=false
run_status=false
run_check=false

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
    --check)
      run_check=true
      shift
      ;;
    --help|-h)
      show_help
      exit 0
      ;;
    *)
      echo "Invalid option: $1"
      show_help
      exit 1
      ;;
  esac
done

$run_packages && install_packages
$run_packages && install_language_tools
$run_packages && configure_docker
$run_packages && configure_login_shell
$run_link && do_link
$run_status && do_status
if $run_check || $run_packages; then
  do_check
fi

echo "Done."
