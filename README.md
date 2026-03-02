# Dotfiles

Personal configurations for Arch Linux.

## Includes
- `alacritty/.config/alacritty/alacritty.toml`
- `bash/.bashrc` (with Starship init)
- `cava/.config/cava/config`
- `fastfetch/.config/fastfetch/config.jsonc`
- `fresh/.config/fresh/config.json`
- `fish/.config/fish/config.fish`
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
# also installs fish and configures it as login shell when possible
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
- The `edit` opener uses `fresh` for text/markdown.
- Versioned files:
  - `~/.config/yazi/yazi.toml` (base behavior)
  - `~/.config/yazi/keymap.toml` (custom keybindings)
  - `~/.config/yazi/theme.toml` (theme aligned with your palette)
- Run with: `yazi`

## Structure
Each configuration root folder (`alacritty`, `bash`, `cava`, `fastfetch`, `fresh`, `fish`, `starship`, `wallpapers`, `yazi`, `zellij`) is a dotfiles module.
Inside each module, the real path in HOME is replicated (`.config/...` or files in `$HOME`).

## Fresh Editor
- Installed with `./install.sh --packages` (package `fresh-editor` in `packages/arch-cli.txt` via AUR/yay).
- Run with: `fresh`
- Linked config path: `~/.config/fresh/config.json`
- Includes language support for: Java, Go, Rust, Python, Web (TS/JS/HTML/CSS/Astro), and LaTeX.

## LaTeX Workflow (Fresh)
- LaTeX toolchain is available (`latexmk`, `pdflatex`) and `texlab` is installed from `packages/languages-tools.txt`.
- Use terminal in Fresh to compile/watch with short aliases:
  - `texb CV-Jorge-Romano.tex` compiles once (`latexmk -pdf -interaction=nonstopmode -synctex=1`)
  - `texw CV-Jorge-Romano.tex` watches and recompiles on save (`-pvc`)
  - `texc CV-Jorge-Romano.tex` cleans auxiliary files
- Aliases are defined in:
  - `bash/.bashrc`
  - `fish/.config/fish/config.fish`

## Wallpapers
- Source folder in the repo: `wallpapers/Pictures/Wallpapers/`
- Final path in your HOME after linking: `~/Pictures/Wallpapers/`
- Place your wallpapers inside this repo folder so everything reads from the same linked path.

## Nitch (Alternative to fastfetch)
- Installation: `./install.sh --packages` (uses `packages/arch-cli.txt`).
- In `fish`, when opening a login shell:
  - uses `nitch` if installed
  - if not, uses `fastfetch` as fallback

## Fish Shell
- Installed with `./install.sh --packages` (package `fish` in `packages/arch-cli.txt`).
- `install.sh` tries to set `fish` as your login shell automatically.
- If it cannot (non-interactive run), use:
```bash
chsh -s "$(command -v fish)"
```

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
