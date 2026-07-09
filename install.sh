#!/usr/bin/env bash
set -eo pipefail

# Ensure script runs from its own directory so '--flake .' works anywhere
cd "$(dirname "$0")"

# Terminal Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Starting ML4W Hyprland Dotfiles Stage 1 Installation...${NC}"

# --- Section 0: System Dependencies ---
if [ -f /etc/debian_version ]; then
    echo -e "${YELLOW}📦 Detecting Debian/Ubuntu. Installing system dependencies...${NC}"
    sudo -v
    sudo apt-get update
    sudo apt-get install -y curl git software-properties-common
    
    if ! grep -q -E "cppiber/hyprland" /etc/apt/sources.list /etc/apt/sources.list.d/* 2>/dev/null; then
        sudo add-apt-repository -y ppa:cppiber/hyprland
    fi
    sudo apt-get update
    sudo apt-get install -y hyprland xdg-desktop-portal-hyprland hyprlock hypridle fcitx5 fcitx5-chinese-addons fcitx5-config-qt
    echo -e "${GREEN}✅ System dependencies installed.${NC}"
fi

# --- Section 1: Nix Installation ---
NIX_BIN_PATH="/nix/var/nix/profiles/default/bin/nix"

if [ ! -f "$NIX_BIN_PATH" ]; then
    echo -e "${YELLOW}📦 Nix not found. Installing Nix...${NC}"
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install linux --no-confirm
    
    if [ ! -f "$NIX_BIN_PATH" ]; then
        echo -e "${RED}❌ Nix installation failed. Cannot continue.${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Nix installation finished.${NC}"
else
    echo -e "${GREEN}✅ Nix is already installed.${NC}"
fi

# --- Section 2: Download Heavy Assets ---
echo -e "${YELLOW}🖼️ Downloading ML4W Official Wallpapers...${NC}"
WALLPAPER_DIR="$HOME/.config/ml4w/wallpapers"
mkdir -p "$WALLPAPER_DIR"
if [ ! -d "$WALLPAPER_DIR/.git" ]; then
    echo -e "${YELLOW}Cloning Stephan Raabe's wallpaper repository...${NC}"
    git clone --depth 1 https://gitlab.com/stephan-raabe/wallpaper.git "$WALLPAPER_DIR/tmp_repo"
    cp -r "$WALLPAPER_DIR/tmp_repo/"* "$WALLPAPER_DIR/"
    rm -rf "$WALLPAPER_DIR/tmp_repo"
    echo -e "${GREEN}✅ Wallpapers downloaded.${NC}"
else
    echo -e "${GREEN}✅ Wallpapers already exist.${NC}"
fi

# --- Section 3: Home Manager Deployment ---
echo -e "${YELLOW}⚙️ Preparing to run Home Manager...${NC}"

# Ensure flakes are enabled for the current user
mkdir -p "$HOME/.config/nix"
if ! grep -q "experimental-features" "$HOME/.config/nix/nix.conf" 2>/dev/null; then
    echo "experimental-features = nix-command flakes" >> "$HOME/.config/nix/nix.conf"
    echo -e "${GREEN}✅ Nix flakes enabled.${NC}"
fi

# Ensure the user's profile directory exists
USER_NIX_PROFILE_DIR="/nix/var/nix/profiles/per-user/$USER"
if [ ! -d "$USER_NIX_PROFILE_DIR" ]; then
    echo -e "${YELLOW}Manually creating Nix user profile directory...${NC}"
    sudo mkdir -p "$USER_NIX_PROFILE_DIR"
    sudo chown "$USER" "$USER_NIX_PROFILE_DIR"
fi

echo -e "${YELLOW}✨ Applying all dotfiles configurations using absolute Nix path... This may take a while.${NC}"

# Apply Home Manager configuration
PATH="/nix/var/nix/profiles/default/bin:$PATH" "$NIX_BIN_PATH" --extra-experimental-features "nix-command flakes" run nixpkgs#home-manager -- switch --flake . --impure -b backup

echo -e "${GREEN}✅ Home Manager configuration applied successfully!${NC}"

# Source the Nix environment in profile
if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
    . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
elif [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

echo ""
echo -e "${GREEN}🎉🎉🎉 Stage 1 installation complete!${NC}"
echo -e "${BLUE}👉 Please log out and choose 'Hyprland' at your login screen to test the ML4W desktop environment.${NC}"
