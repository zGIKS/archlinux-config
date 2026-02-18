# Dotfiles

Configuraciones personales para Arch Linux.

## Incluye
- `alacritty/.config/alacritty/alacritty.toml`
- `bash/.bashrc` (con init de Starship)
- `cava/.config/cava/config`
- `fastfetch/.config/fastfetch/config.jsonc`
- `fish/.config/fish/config.fish`
- `starship/.config/starship.toml`
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
Cada carpeta raiz (`alacritty`, `bash`, `cava`, `fastfetch`, `fish`, `starship`, `yay`) es un paquete de dotfiles.
Dentro de cada paquete se replica la ruta real en HOME (`.config/...`).

## Nitch (alternativa a fastfetch)
- Instalacion: `./install.sh --packages` (usa `packages/arch-cli.txt`).
- En `fish`, al abrir una shell login:
  - usa `nitch` si esta instalado
  - si no, usa `fastfetch` como fallback
