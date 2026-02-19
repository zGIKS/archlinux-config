# Dotfiles

Configuraciones personales para Arch Linux.

## Incluye
- `alacritty/.config/alacritty/alacritty.toml`
- `bash/.bashrc` (con init de Starship)
- `cava/.config/cava/config`
- `fastfetch/.config/fastfetch/config.jsonc`
- `fresh/.config/fresh/config.json`
- `fish/.config/fish/config.fish`
- `starship/.config/starship.toml`
- `yazi/.config/yazi/yazi.toml`
- `yazi/.config/yazi/keymap.toml`
- `yazi/.config/yazi/theme.toml`
- `packages/arch-cli.txt` (paquetes CLI recomendados)
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
- Archivos versionados:
  - `~/.config/yazi/yazi.toml` (comportamiento base)
  - `~/.config/yazi/keymap.toml` (atajos propios)
  - `~/.config/yazi/theme.toml` (tema alineado con tu paleta)
- Ejecutar con: `yazi`

## Fresh
- Se instala con `./install.sh --packages` (paquete `fresh-editor` en AUR).
- Se enlaza con `./install.sh --link` hacia `~/.config/fresh/config.json`.
- Ejecutar con: `fresh`

## Estructura
Cada carpeta raiz de configuracion (`alacritty`, `bash`, `cava`, `fastfetch`, `fresh`, `fish`, `starship`, `yazi`) es un modulo de dotfiles.
Dentro de cada modulo se replica la ruta real en HOME (`.config/...` o archivos en `$HOME`).

## Nitch (alternativa a fastfetch)
- Instalacion: `./install.sh --packages` (usa `packages/arch-cli.txt`).
- En `fish`, al abrir una shell login:
  - usa `nitch` si esta instalado
  - si no, usa `fastfetch` como fallback
