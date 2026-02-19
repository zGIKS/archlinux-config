#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Keep PATH ordering deterministic across sessions.
path_prepend() {
  local dir="${1:-}"
  [[ -n "$dir" && -d "$dir" ]] || return 0
  local path=":${PATH}:"
  path="${path//:${dir}:/:}"
  path="${path#:}"
  path="${path%:}"
  PATH="${dir}${path:+:${path}}"
}

path_append() {
  local dir="${1:-}"
  [[ -n "$dir" && -d "$dir" ]] || return 0
  local path=":${PATH}:"
  path="${path//:${dir}:/:}"
  path="${path#:}"
  path="${path%:}"
  PATH="${path:+${path}:}${dir}"
}

path_dedupe_all() {
  local -A seen=()
  local part
  local out=()
  local old_ifs="$IFS"
  IFS=':'
  for part in $PATH; do
    [[ -n "$part" ]] || continue
    if [[ -z "${seen[$part]:-}" ]]; then
      out+=("$part")
      seen["$part"]=1
    fi
  done
  IFS="$old_ifs"
  PATH="$(IFS=:; echo "${out[*]}")"
}

export BUN_INSTALL="$HOME/.bun"
export VOLTA_HOME="$HOME/.volta"

# Load tool-provided env first, then normalize PATH order below.
if [[ -r "$HOME/.local/bin/env" ]]; then
  . "$HOME/.local/bin/env"
fi
if [[ -r "$HOME/.cargo/env" ]]; then
  . "$HOME/.cargo/env"
fi

# Priority order for Node/tooling shims.
path_prepend "$VOLTA_HOME/bin"
path_prepend "$HOME/.local/bin"
path_prepend "$BUN_INSTALL/bin"
path_prepend "$HOME/.cargo/bin"
path_prepend "$HOME/go/bin"
path_append "$HOME/.spicetify"
path_dedupe_all

export PATH

# Bash completion (command and option completion)
if [[ -r /usr/share/bash-completion/bash_completion ]]; then
  . /usr/share/bash-completion/bash_completion
fi

# Better interactive completion experience in Bash
bind 'set show-all-if-ambiguous on'
bind 'set completion-ignore-case on'
bind 'set colored-stats on'
bind 'TAB:menu-complete'
bind '"\e[Z":menu-complete-backward'

# Starship prompt
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi
