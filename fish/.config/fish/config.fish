if status is-interactive
    # Fish colors aligned with Alacritty glass palette
    set -g fish_color_normal f5f5f7
    set -g fish_color_command 0a84ff
    set -g fish_color_param f5f5f7
    set -g fish_color_keyword bf5af2
    set -g fish_color_quote 32d74b
    set -g fish_color_redirection 64d2ff
    set -g fish_color_end ffd60a
    set -g fish_color_error ff453a
    set -g fish_color_comment 3a3a3c
    set -g fish_color_operator 64d2ff
    set -g fish_color_escape ffd60a
    set -g fish_color_autosuggestion 3a3a3c
    set -g fish_color_search_match --background=1c1c1e
    set -g fish_color_selection --background=0a84ff

    # Starship prompt for fish
    if command -v starship >/dev/null 2>&1
        starship init fish | source
    end

end

# Disable fish welcome message
set -g fish_greeting
