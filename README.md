# NixOS Configuration

Clean, modular NixOS configuration for multiple hosts with centralized management.

## 🏠 Hosts

| Host | Device | GPU | Features |
|------|--------|-----|----------|
| `maibenben` | Maibenben x525 | NVIDIA RTX 4060 | Gaming, Docker+NVIDIA |
| `thinkpad` | ThinkPad X1 Carbon Gen 13 | Intel Integrated | Power management, Ultrabook |

## 📁 Structure

```
nixos-config/
├── flake.nix           # Entry point
├── flake.lock
├── lib/
│   └── default.nix     # Central constants & version management
├── hosts/
│   ├── maibenben/      # Gaming laptop
│   └── thinkpad/       # Ultrabook
├── modules/
│   ├── core/           # Base system (boot, nix, networking, users)
│   ├── desktop/        # GNOME, Hyprland, Stylix
│   ├── hardware/       # NVIDIA, power management, disko
│   ├── shell/          # Fish, starship, aliases
│   └── programs/       # Applications, virtualization, gaming
├── devshells/          # Development environments
└── wallpapers/         # Wallpaper files
```

## 🚀 Quick Start

### Deploy to a host

```bash
# From the config directory
sudo nixos-rebuild switch --flake .#maibenben
# or
sudo nixos-rebuild switch --flake .#thinkpad

# Using nh (recommended)
nh os switch .
```

### Update flake inputs

```bash
nix flake update
```

### Enter a development shell

```bash
# General development
nix develop .#dev

# CTF/Security
nix develop .#ctf

# Rust development
nix develop .#rust

# Python development
nix develop .#python

# Embedded systems
nix develop .#embedded

# Web development
nix develop .#web

# Go development
nix develop .#go
```

## ⚙️ Version Management

Edit `lib/default.nix` to change the NixOS version for all hosts:

```nix
# Options: "25.05", "25.11", "unstable"
nixosVersion = "25.11";
```

## ⌨️ Keybindings

### Hyprland

| Binding | Action |
|---------|--------|
| `Super + Return` | Terminal |
| `Super + R` | App launcher |
| `Super + E` | File manager |
| `Super + C` | Close window |
| `Super + F` | Toggle floating |
| `Super + U` | Fullscreen |
| `Super + H/J/K/L` | Focus left/down/up/right |
| `Super + Ctrl + H/J/K/L` | Resize window |
| `Super + Ctrl + Shift + H/J/K/L` | Move window |
| `Super + 1-0` | Switch workspace |
| `Super + Shift + 1-0` | Move to workspace |
| `Super + V` | Clipboard history |
| `Print` | Screenshot (selection) |
| `Super + Shift + L` | Lock screen |

### Fish Shell Aliases

| Alias | Command |
|-------|---------|
| `ls/l/ll/la` | eza variants |
| `o/v/vim` | neovim |
| `lg` | lazygit |
| `update` | `nh os switch` |
| `dev/ctf/rust/py` | Enter dev shells |

## 🔧 Hardware-Specific Notes

### Maibenben x525 (NVIDIA)

- PRIME offload mode enabled (use `nvidia-offload` for GPU tasks)
- VRAM preservation for suspend/resume
- Docker with NVIDIA support

### ThinkPad X1 Carbon Gen 13

- TLP power management
- Battery charge thresholds (75-80%)
- Fingerprint reader support
- Firmware updates via fwupd

## 📦 Key Features

- **GNOME** as default DE
- **Hyprland** available (power-efficient config)
- **Stylix** theming (Catppuccin Macchiato)
- **Fish** shell with modern CLI tools
- **Rust** nightly toolchain with cross-compilation
- **Development shells** for CTF, embedded, web, etc.
- **Disko** for declarative disk management
- **LUKS** encryption with optional FIDO2

## 🔐 First-Time Setup

1. Boot NixOS installer
2. Partition disk (or use disko)
3. Copy this config to `/mnt/etc/nixos` or your preferred location
4. Generate hardware config: `nixos-generate-config --root /mnt`
5. Copy generated hardware-configuration.nix to the appropriate host
6. Install: `nixos-install --flake .#<hostname>`

## 📝 Notes

- Edit `hosts/*/hardware-configuration.nix` with your actual disk UUIDs
- Secrets management not included (consider sops-nix)
- Tailscale DNS configured for maibenben
