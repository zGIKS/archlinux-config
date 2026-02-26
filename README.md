# Dotfiles

Personal configurations for Arch Linux.

## Includes
- `alacritty/.config/alacritty/alacritty.toml`
- `bash/.bashrc` (with Starship init)
- `cava/.config/cava/config`
- `fastfetch/.config/fastfetch/config.jsonc`
- `fish/.config/fish/config.fish`
- `nvim/.config/nvim/init.lua`
- `starship/.config/starship.toml`
- `tmux/.tmux.conf`
- `wallpapers/Pictures/Wallpapers/` (links to `~/Pictures/Wallpapers`)
- `yazi/.config/yazi/yazi.toml`
- `yazi/.config/yazi/keymap.toml`
- `yazi/.config/yazi/theme.toml`
- `packages/arch-cli.txt` (recommended CLI packages)
  - includes `docker`, `docker-compose`, and `docker-buildx`
- `packages/volta-cli.txt` (Global Node CLIs managed with Volta)
  - if no fixed version is specified, it installs the latest available version

## Quick Start
```bash
cd ~/dotfiles
./install.sh --packages --link
```

## Useful Commands
```bash
# Only create/link symlinks
./install.sh --link

# Only install packages listed in packages/arch-cli.txt
# and Node CLIs listed in packages/volta-cli.txt (if volta is installed)
# also configures Docker on Arch (service + docker group)
./install.sh --packages

# Check PATH order and command resolution (node/npm/gemini)
./install.sh --check

# View link status
./scripts/status.sh

# Reload current shell after dotfiles changes
./scripts/reload-shell.sh
```

## Yazi
- Installed with `./install.sh --packages` (package `yazi` in `packages/arch-cli.txt`).
- Linked with `./install.sh --link` to `~/.config/yazi/`.
- The `edit` opener uses `nvim` for text/markdown.
- Versioned files:
  - `~/.config/yazi/yazi.toml` (base behavior)
  - `~/.config/yazi/keymap.toml` (custom keybindings)
  - `~/.config/yazi/theme.toml` (theme aligned with your palette)
- Run with: `yazi`

## Structure
Each configuration root folder (`alacritty`, `bash`, `cava`, `fastfetch`, `fish`, `nvim`, `starship`, `tmux`, `wallpapers`, `yazi`) is a dotfiles module.
Inside each module, the real path in HOME is replicated (`.config/...` or files in `$HOME`).

## Neovim
- Installed with `./install.sh --packages` (package `neovim` in `packages/arch-cli.txt`).
- Linked with `./install.sh --link` to `~/.config/nvim/init.lua`.
- Base configuration included:
  - line numbers (`number` + `relativenumber`)
  - 2-space indentation
  - system clipboard (`unnamedplus`)
  - `<leader>` shortcuts (save/close/splits)

## Wallpapers
- Source folder in the repo: `wallpapers/Pictures/Wallpapers/`
- Final path in your HOME after linking: `~/Pictures/Wallpapers/`
- Place your wallpapers inside this repo folder so everything reads from the same linked path.

## Nitch (Alternative to fastfetch)
- Installation: `./install.sh --packages` (uses `packages/arch-cli.txt`).
- In `fish`, when opening a login shell:
  - uses `nitch` if installed
  - if not, uses `fastfetch` as fallback

## Docker on Arch Linux
- `./install.sh --packages` installs:
  - `docker`
  - `docker-compose` (Compose v2, use `docker compose`)
  - `docker-buildx`
- After installation, the script:
  - enables/starts `docker.service` with `systemd`
  - adds your user to the `docker` group if missing
- Quick verification:
```bash
docker --version
docker compose version
docker buildx version
systemctl status docker --no-pager
```
