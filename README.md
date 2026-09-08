# Nix + ML4W Hyprland Dotfiles

[![Nix](https://img.shields.io/badge/Nix-Home_Manager-blue?logo=nixos&logoColor=white)](https://nixos.org)
[![Hyprland](https://img.shields.io/badge/Hyprland-Wayland-00c853?logo=hyprland&logoColor=white)](https://hyprland.org)
[![ML4W](https://img.shields.io/badge/ML4W-Dotfiles-orange)](https://github.com/mylinuxforwork)
[![Platform](https://img.shields.io/badge/Platform-Arch%20Linux%20%7C%20Ubuntu%20%7C%20Debian-lightgrey?logo=archlinux&logoColor=white)](https://archlinux.org)

A personal, modular **Home Manager (Nix Flake)** configuration tailored for **Arch Linux & Ubuntu/Debian + Hyprland**. It manages CLI tools, shell environments, development workflows, and desktop assets declaratively.

> [!NOTE]
> **Not a full NixOS configuration**: This setup runs on standard Linux distributions (`genericLinux` target). Hyprland and `xdg-desktop-portal-hyprland` are provided via system packages/PPAs, while Home Manager manages all user-space configurations, tools, and environments. Target architecture: `x86_64-linux` (`/home/$USER`).

---

## 🛠️ Key Features

- **Hyprland + ML4W Desktop Suite**: Configurations for Hyprland window manager, Waybar status bar, Rofi, Walker launcher, SwayNC notification center, nwg-dock, wallpaper management, and ML4W system resources.
- **Quickshell Workspace Overview**: Base panels, settings menu, and interactive workspace overview managed as systemd user services (source located at `nix/modules/desktop/assets/quickshell/overview/`).
- **Pragmatic Shell Environment**:
  - Shared configuration and **Starship** prompt across **Zsh**, **Bash**, and **Nushell**.
  - **Container Awareness (Container Shield)**: Automatically disables unsupported deep aliases inside Docker or Distrobox containers to prevent session issues.
  - **Responsive Auto-Suggestions**: Lightweight inline ghost-text completion (`Zsh Autosuggestions` with `→` to accept) without bloated popup lag.
  - **SSH Friendly**: Avoids auto-starting Zellij over SSH connections to prevent nested multiplexer sessions.
- **DevOps & CLI Toolkit**:
  - **Neovim**: Tailored for DevOps and configuration editing with preconfigured LSPs (YAML, Bash, Dockerfile, Lua).
  - **Zellij**: Modern terminal multiplexer with Tmux-style shortcuts (run `zj_shortcuts` in terminal for a cheat sheet).
  - **Modern Rust CLI replacements**: `eza` (modern `ls`), `bat` (syntax-highlighted `cat`), `btop` (resource monitor), `ripgrep`, `fd`, `lazygit`, `jq`, `yq`.
  - **Shortcuts**: `k` (`kubectl`) and `h` (`helm`) with dynamic completion caching when installed.
- **Unified Dark Theme**: Adwaita Dark, Papirus Dark icons, Bibata cursor, and Maple Mono NF monospace font.

---

## ⚠️ Important Notes

1. **Zellij**: Configured but not forced on startup. Launch manually with `zellij` or `zj`. It automatically selects lightweight/remote configurations in SSH or container sessions.
2. **Kubernetes & Helm Shortcuts**: `k` and `h` are aliased to `kubectl` and `helm`. They are not pre-installed by the flake; Zsh generates and caches completions only if the binaries exist on your machine.
3. **Nushell Completions**: Configured with Carapace integration. Ensure `carapace` is in your `PATH` if using Nushell.
4. **Distro Compatibility**: The automated installer (`install.sh`) targets Debian/Ubuntu (using `apt`). Other Linux distributions can still use the flake after manually installing Hyprland, portals, and input method dependencies.

---

## 📦 Installation & Quick Start

### Prerequisites
- 64-bit x86 Linux machine (`/home/$USER`).
- Ubuntu or Debian with `sudo` privileges (for `apt` dependency resolution).
- Active internet connection, `git`, and `curl`.

> [!IMPORTANT]
> **Backup Recommended**: Back up any existing `~/.config/hypr/` or `~/.config/ml4w/` configurations before the first run. During activation, custom files like `monitors.lua`, `colors.conf`, `colors.lua`, `custom.lua`, and custom wallpapers in `~/.config/ml4w/` are preserved; other managed files will sync with the repository.

### Quick Setup

```bash
# Clone the repository
git clone https://github.com/jin00100/home_env_dotfiles-ML4W.git "$HOME/home_env_dotfiles-ML4W"

# Enter directory and run the installer
cd "$HOME/home_env_dotfiles-ML4W"
chmod +x install.sh
./install.sh
```

**What `install.sh` Does:**
1. Installs base system dependencies (`hyprland`, `xdg-desktop-portal-hyprland`, `hyprlock`, `hypridle`, `fcitx5`).
2. Installs the Nix package manager via Determinate Systems installer (if not already present).
3. Enables Nix Flakes and initializes user profiles.
4. Executes the initial Home Manager switch (`home-manager switch --flake . --impure -b backup`).

After installation finishes, log out and select the **Hyprland** session from your display manager (GDM/SDDM/LightDM).

---

## 🔄 Daily Workflow & Maintenance

Because configuration is managed declaratively through Git and Nix, workflow changes are applied via the following commands:

### 1. Fast Rebuild (`hms`)
After editing Nix files or assets inside the repo, apply updates with:

```bash
hms
```

> `hms` is an alias for `home-manager switch --flake "$HOME/home_env_dotfiles-ML4W#$USER" --impure -b backup`. It applies changes smoothly and automatically backs up conflicting files as `.backup`.

### 2. Upgrading Flake Packages (`update.sh`)
To fetch the latest upstream packages from Nixpkgs and rebuild:

```bash
./update.sh
```

### 3. Reloading Desktop Services
If you edited Hyprland or Quickshell configurations:

```bash
# Reload Hyprland configuration
hyprctl reload

# Restart Quickshell overview service
systemctl --user restart ml4w-quickshell-overview.service
```

### 4. Garbage Collection (`nix-clean`)
To free up disk space by cleaning old generations and running store garbage collection:

```bash
nix-clean
```

---

## 📂 Configuration Mapping

The repository acts as the single source of truth. Home Manager maps files into your user environment:

| Component | Source Path in Repo | Target Path in `$HOME` |
| :--- | :--- | :--- |
| **Hyprland** | `nix/modules/desktop/assets/hypr/` | `~/.config/hypr/` |
| **ML4W Settings & Assets** | `nix/modules/desktop/assets/ml4w/` | `~/.config/ml4w/` |
| **Quickshell Overview** | `nix/modules/desktop/assets/quickshell/overview/` | `~/.config/quickshell/overview/` |
| **Waybar / Rofi / Walker** | `nix/modules/desktop/assets/{waybar,rofi,walker}/` | `~/.config/{waybar,rofi,walker}/` |
| **Neovim** | `nix/modules/dev/nvim/` | `~/.config/nvim/` |
| **Zellij** | `nix/modules/dev/zellij.nix` | `~/.config/zellij/` |
| **Ghostty / Kitty** | `nix/modules/desktop/{ghostty,kitty}.nix` | `~/.config/{ghostty,kitty}/` |

> [!TIP]
> Always edit the source files in `~/home_env_dotfiles-ML4W/` and then run `hms`. Direct edits in `~/.config/` may be overwritten during future rebuilds (except for user-protected files like `monitors.lua` and custom wallpapers).

---

The default terminal is Kitty, launched with `nixGL kitty` through
`~/.config/ml4w/settings/terminal.sh`. `Super + Enter` uses this setting.
Keep the setting as a single command
line because ML4W utilities read it to launch terminal applications.
Home Manager preserves existing `ml4w/settings`, so existing installations
must also update their live `terminal.sh` when changing this repository default.

## 📁 Repository Structure

```text
home_env_dotfiles-ML4W/
├── flake.nix                         # Flake entry point (builds configuration for $USER)
├── flake.lock                        # Pinned Nix flake inputs
├── install.sh                        # Automated installer for Ubuntu/Debian
├── update.sh                         # Flake update & rebuild script
├── nix/
│   ├── home.nix                      # Main Home Manager entry, aliases, session variables
│   └── modules/
│       ├── core/                     # CLI utilities (eza, bat, btop) & fonts (Maple Mono)
│       ├── dev/                      # Dev tools, Neovim, Zellij multiplexer, Git configuration
│       ├── desktop/                  # GUI apps, theme, Quickshell services, Wayland tools
│       │   └── assets/               # Dotfiles source assets (Hyprland, ML4W, Waybar, etc.)
│       └── shell/                    # Shell modules (Zsh, Bash, Nushell) & environment shields
└── doc/
    └── 系统使用指南.md                # System user manual, rescue guide & shortcut reference
```

---

## 🔧 Troubleshooting & Recovery

- **Rebuild Errors**: If `hms` fails, check the terminal output for specific file conflicts or syntax errors.
- **Backup File Conflict**: If an error mentions `.backup` already existing, review the conflicting file in `~/.config/` and remove or merge the old `.backup` file.
- **Emergency Desktop Reload**: Press `Super + Shift + R` to reload Hyprland instantly.
- **TTY Rescue Mode**:
  1. If the graphical environment crashes, press `Ctrl + Alt + F3` to access TTY.
  2. Log in and navigate to the repo: `cd ~/home_env_dotfiles-ML4W`.
  3. Discard faulty changes: `git checkout -- .`.
  4. Run `hms` to redeploy the clean configuration.
  5. Press `Ctrl + Alt + F1` (or `F7`) to return to your GUI desktop.
- **Dual Monitor Workspaces (Hyprland 0.55+ Lua Dispatcher)**:
  ```bash
  # Move workspace 3 to secondary monitor (e.g., DP-2)
  hyprctl eval 'hl.dispatch(hl.dsp.workspace.move({ workspace = "3", monitor = "DP-2" }))'
  ```

---

## 🙏 Acknowledgements

- Special thanks to [`yongminari`](https://github.com/yongminari/home_env_dotfiles) for the base dotfiles architecture and configurations.