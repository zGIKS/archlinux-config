#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

export PATH="$HOME/.local/bin:$PATH"

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

source /usr/share/nvm/init-nvm.sh

export PATH="$PATH:$HOME/.spicetify"

. "$HOME/.local/bin/env"

export PATH="$HOME/go/bin:$PATH"


# Add Cargo binaries to PATH (for trunk, cargo, etc.)
export PATH="$HOME/.cargo/bin:$PATH"
. "$HOME/.cargo/env"

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
