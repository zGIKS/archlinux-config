#!/usr/bin/env bash
set -euo pipefail

fail=0

report_fail() {
  echo "FAIL: $*"
  fail=1
}

report_warn() {
  echo "WARN: $*"
}

check_no_duplicates() {
  local name="$1"
  local path_value="$2"
  local total unique
  total=$(tr ':' '\n' <<<"$path_value" | sed '/^$/d' | wc -l)
  unique=$(tr ':' '\n' <<<"$path_value" | sed '/^$/d' | awk '!seen[$0]++' | wc -l)
  if [[ "$total" -ne "$unique" ]]; then
    report_fail "$name PATH tiene entradas duplicadas ($total totales, $unique unicas)."
  else
    echo "OK: $name PATH sin duplicados"
  fi
}

echo "== Bash checks =="
if BASH_OUT=$(bash -ic 'printf "PATH=%s\n" "$PATH"; command -v node; command -v npm; command -v gemini || true' 2>/dev/null); then
  BASH_PATH=$(awk -F'PATH=' 'NR==1 {print $2}' <<<"$BASH_OUT")
  BASH_NODE=$(sed -n '2p' <<<"$BASH_OUT")
  BASH_NPM=$(sed -n '3p' <<<"$BASH_OUT")
  BASH_GEMINI=$(sed -n '4p' <<<"$BASH_OUT")

  check_no_duplicates "bash" "$BASH_PATH"
  [[ "$BASH_NODE" == "$HOME/.volta/bin/"* ]] || report_fail "bash usa node desde '$BASH_NODE'"
  [[ "$BASH_NPM" == "$HOME/.volta/bin/"* ]] || report_fail "bash usa npm desde '$BASH_NPM'"

  if [[ -z "$BASH_GEMINI" ]]; then
    report_warn "bash no encuentra gemini (si no lo usas, puedes ignorar esto)."
  elif [[ "$BASH_GEMINI" != "$HOME/.volta/bin/"* ]]; then
    report_fail "bash usa gemini desde '$BASH_GEMINI'"
  else
    echo "OK: bash gemini -> $BASH_GEMINI"
  fi

  [[ "$BASH_NODE" == "$HOME/.volta/bin/"* ]] && echo "OK: bash node -> $BASH_NODE"
  [[ "$BASH_NPM" == "$HOME/.volta/bin/"* ]] && echo "OK: bash npm -> $BASH_NPM"
else
  report_fail "No se pudo evaluar bash con ~/.bashrc"
fi

echo
if command -v fish >/dev/null 2>&1; then
  echo "== Fish checks =="
  if FISH_OUT=$(fish -lc 'printf "%s\n" "PATH=$PATH"; command -v node; command -v npm; command -v gemini' 2>/dev/null); then
    FISH_PATH=$(awk -F'PATH=' 'NR==1 {print $2}' <<<"$FISH_OUT")
    FISH_NODE=$(sed -n '2p' <<<"$FISH_OUT")
    FISH_NPM=$(sed -n '3p' <<<"$FISH_OUT")
    FISH_GEMINI=$(sed -n '4p' <<<"$FISH_OUT")

    check_no_duplicates "fish" "$FISH_PATH"

    [[ "$FISH_NODE" == "$HOME/.volta/bin/"* ]] || report_fail "fish usa node desde '$FISH_NODE'"
    [[ "$FISH_NPM" == "$HOME/.volta/bin/"* ]] || report_fail "fish usa npm desde '$FISH_NPM'"

    if [[ -z "$FISH_GEMINI" ]]; then
      report_warn "fish no encuentra gemini (si no lo usas, puedes ignorar esto)."
    elif [[ "$FISH_GEMINI" != "$HOME/.volta/bin/"* ]]; then
      report_fail "fish usa gemini desde '$FISH_GEMINI'"
    else
      echo "OK: fish gemini -> $FISH_GEMINI"
    fi

    [[ "$FISH_NODE" == "$HOME/.volta/bin/"* ]] && echo "OK: fish node -> $FISH_NODE"
    [[ "$FISH_NPM" == "$HOME/.volta/bin/"* ]] && echo "OK: fish npm -> $FISH_NPM"
  else
    report_warn "No se pudo evaluar fish; valida manualmente con: type -a node npm gemini"
  fi
fi

echo
if [[ "$fail" -ne 0 ]]; then
  echo "PATH check: FAILED"
  exit 1
fi

echo "PATH check: OK"
