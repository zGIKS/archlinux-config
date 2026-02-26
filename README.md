# Dotfiles

Configuraciones personales para Arch Linux.

## Incluye
- `alacritty/.config/alacritty/alacritty.toml`
- `bash/.bashrc` (con init de Starship)
- `cava/.config/cava/config`
- `fastfetch/.config/fastfetch/config.jsonc`
- `fish/.config/fish/config.fish`
- `nvim/.config/nvim/init.lua`
- `starship/.config/starship.toml`
- `tmux/.tmux.conf`
- `wallpapers/Pictures/Wallpapers/` (enlaza a `~/Pictures/Wallpapers`)
- `yazi/.config/yazi/yazi.toml`
- `yazi/.config/yazi/keymap.toml`
- `yazi/.config/yazi/theme.toml`
- `packages/arch-cli.txt` (paquetes CLI recomendados)
  - incluye `docker`, `docker-compose` y `docker-buildx`
- `packages/volta-cli.txt` (CLIs globales de Node gestionados con Volta)
  - si no hay version fijada, instala la version mas reciente disponible

## Uso rapido
```bash
cd ~/dotfiles
./install.sh --packages --link
```

## Comandos utiles
```bash
# Solo crear/enlazar symlinks
./install.sh --link

# Solo instalar paquetes listados en packages/arch-cli.txt
# y CLIs de Node listados en packages/volta-cli.txt (si volta esta instalado)
# tambien configura Docker en Arch (servicio + grupo docker)
./install.sh --packages

# Verificar orden de PATH y resolucion de comandos (node/npm/gemini)
./install.sh --check

# Ver estado de enlaces
./scripts/status.sh

# Recargar shell actual tras cambios de dotfiles
./scripts/reload-shell.sh
```

## Yazi
- Se instala con `./install.sh --packages` (paquete `yazi` en `packages/arch-cli.txt`).
- Se enlaza con `./install.sh --link` hacia `~/.config/yazi/`.
- El opener `edit` usa `nvim` para texto/markdown.
- Archivos versionados:
  - `~/.config/yazi/yazi.toml` (comportamiento base)
  - `~/.config/yazi/keymap.toml` (atajos propios)
  - `~/.config/yazi/theme.toml` (tema alineado con tu paleta)
- Ejecutar con: `yazi`

## Estructura
Cada carpeta raiz de configuracion (`alacritty`, `bash`, `cava`, `fastfetch`, `fish`, `nvim`, `starship`, `tmux`, `wallpapers`, `yazi`) es un modulo de dotfiles.
Dentro de cada modulo se replica la ruta real en HOME (`.config/...` o archivos en `$HOME`).

## Neovim
- Se instala con `./install.sh --packages` (paquete `neovim` en `packages/arch-cli.txt`).
- Se enlaza con `./install.sh --link` hacia `~/.config/nvim/init.lua`.
- Configuracion base incluida:
  - numeros de linea (`number` + `relativenumber`)
  - indentacion a 2 espacios
  - portapapeles del sistema (`unnamedplus`)
  - atajos con `<leader>` (guardar/cerrar/splits)

## Wallpapers
- Carpeta fuente en el repo: `wallpapers/Pictures/Wallpapers/`
- Ruta final en tu HOME tras enlazar: `~/Pictures/Wallpapers/`
- Coloca tus wallpapers dentro de esa carpeta del repo para que todo lea desde la misma ruta enlazada.

## Nitch (alternativa a fastfetch)
- Instalacion: `./install.sh --packages` (usa `packages/arch-cli.txt`).
- En `fish`, al abrir una shell login:
  - usa `nitch` si esta instalado
  - si no, usa `fastfetch` como fallback

## Docker en Arch Linux
- `./install.sh --packages` instala:
  - `docker`
  - `docker-compose` (Compose v2, usar `docker compose`)
  - `docker-buildx`
- Tras instalar, el script:
  - habilita/inicia `docker.service` con `systemd`
  - agrega tu usuario al grupo `docker` si falta
- Verificacion rapida:
```bash
docker --version
docker compose version
docker buildx version
systemctl status docker --no-pager
```
