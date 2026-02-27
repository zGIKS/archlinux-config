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
- `zellij/.config/zellij/config.kdl`
- `wallpapers/Pictures/Wallpapers/` (links to `~/Pictures/Wallpapers`)
- `yazi/.config/yazi/yazi.toml`
- `yazi/.config/yazi/keymap.toml`
- `yazi/.config/yazi/theme.toml`
- `packages/arch-cli.txt` (recommended CLI packages)
- `packages/languages-tools.txt` (single manifest for Python/Go/Rust/Java/Node/Docker tooling)
  - includes language runtimes plus toolchains/tooling (Rust, Go, Node via Volta, Docker, UV)

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
# plus language runtimes/tooling from packages/languages-tools.txt
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
Each configuration root folder (`alacritty`, `bash`, `cava`, `fastfetch`, `fish`, `nvim`, `starship`, `wallpapers`, `yazi`, `zellij`) is a dotfiles module.
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
- `./install.sh --packages` installs from `packages/languages-tools.txt`:
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

## Python with UV
- `uv` is installed with `./install.sh --packages` (from `packages/languages-tools.txt`).
- Keep using `pip` only as compatibility fallback for legacy scripts.
- Recommended daily workflow:
```bash
uv venv
source .venv/bin/activate
uv pip install -r requirements.txt
```
