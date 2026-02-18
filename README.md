# Dotfiles

Configuraciones personales para Arch Linux.

## Incluye
- `alacritty/.config/alacritty/alacritty.toml`
- `cava/.config/cava/config`
- `fastfetch/.config/fastfetch/config.jsonc`
- `yay/.config/yay/` (normalmente vacio, pero versionado)
- `packages/arch-cli.txt` (paquetes CLI recomendados)

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
./install.sh --packages

# Ver estado de enlaces
./scripts/status.sh
```

## Estructura
Cada carpeta raiz (`alacritty`, `cava`, `fastfetch`) es un paquete de dotfiles.
Dentro de cada paquete se replica la ruta real en HOME (`.config/...`).
