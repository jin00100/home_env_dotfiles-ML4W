# 🚀 Nix DevOps Workspace (ML4W Companion)

This repository contains a fully declarative **Home Manager flake** designed to provide a robust, modern CLI and DevOps environment on top of non-NixOS distributions (like Ubuntu, Debian, or Arch Linux). It is designed to work seamlessly alongside [ML4W Hyprland dotfiles](https://github.com/mylinuxforwork/dotfiles).

## ✨ Core Features & Architecture

This repository has been strictly refactored into a **pure modular architecture**, separating UI components from core DevOps tooling.

### 🧬 Modular System
- **`system-utils.nix`**: Core CLI tools, system monitors (btop, htop), and rust-based utilities (eza, bat, fd).
- **`dev-tools.nix`**: Developer dependencies, including language servers (LSP) for YAML, Bash, and Docker.
- **`gui-apps.nix`**: Wayland GUI applications, Hyprland utilities, and system tray applets.
- **`theme.nix`**: Centralized GTK themes, icons, and cursor management.

### 🛡️ DevOps Terminal & Shell (Error Shield)
- **Container & SSH Awareness**: Powered by a unified `shell-common.sh`, the terminal automatically detects if it's running inside a Docker/Distrobox container or an SSH session. It disables overly complex aliases that would crash in naked Linux environments.
- **Top-Tier Autocompletion**:
  - `Zsh`: Equipped with `zsh-autocomplete` for modern multi-line parameter dropdowns.
  - `Nushell`: Integrated with `Carapace` for fuzzy-searching command arguments.
  - Caches `kubectl` and `helm` completions for instant startup.
- **Terminal Multiplexer (`Zellij`)**: Autostarts on interactive shells (smartly bypassing VSCode and SSH sessions to prevent nested terminal issues).

### 🛠️ DevOps Neovim (`plugins.lua`)
Tailored specifically for infrastructure engineers and system administrators:
- **Container Piercing**: Can seamlessly read system files from inside Distrobox containers using `cat`.
- **YAML & Shell Mastery**: Strict `Tree-sitter` indentation and LSP symbol highlighting for rapid debugging.
- **Lightweight**: Intentionally stripped of heavy C/C++ analysis tools to maximize startup speed and battery life.

## 📦 Prerequisites

- A fresh installation of **Ubuntu / Debian** (or another Linux distribution).
- **Git** installed to clone this repository.

## 🚀 Installation (One-Click)

This repository includes a robust `install.sh` script that automates the entire setup.

1. **Clone the Repository**: 
   ```bash
   git clone https://github.com/YOUR_USERNAME/home_env_dotfiles-ML4W.git ~/home_env_dotfiles-ML4W
   cd ~/home_env_dotfiles-ML4W
   ```

2. **Run the Installer**:
   Execute the installation script. It will ask for your `sudo` password to install underlying system packages before handing off to Nix.
   ```bash
   ./install.sh
   ```

3. **Log In**:
   Once the script finishes successfully, log out and choose the **Hyprland** session at your login screen.

## 🛠️ Usage & Updating

Managing your environment is incredibly easy using built-in aliases.

- **Updating Configurations**:
  Whenever you modify a `.nix` file in this repository, just run:
  ```bash
  nix run home-manager/master -- switch --flake ~/home_env_dotfiles-ML4W/#$USER --impure -b backup
  ```
  *(Tip: You can alias this to `hms` in your shell config)*

- **Cleaning up Nix Store**:
  To safely delete old generations and free up disk space, run:
  ```bash
  nix-clean
  ```

## 📁 Directory Structure

```text
home_env_dotfiles-ML4W/
├── flake.nix                 # Flake entrypoint
├── nix/
│   ├── home.nix              # Main Home Manager entrypoint (imports modules)
│   └── modules/
│       ├── core/             # system-utils.nix, fonts.nix
│       ├── desktop/          # gui-apps.nix, theme.nix, hyprland.nix
│       ├── dev/              # dev-tools.nix, Neovim & Git configs
│       └── shell/            # shell-common.sh, zsh.nix, nushell.nix
```


