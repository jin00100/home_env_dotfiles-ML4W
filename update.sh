#!/usr/bin/env bash
set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Enter the ML4W dotfiles directory
cd ~/home_env_dotfiles-ML4W

echo -e "${BLUE}🚀 Fetching the latest global tool versions from Nixpkgs (nix flake update)...${NC}"
nix flake update

echo -e "${BLUE}🔄 Applying the latest GUI versions and hot-reloading configurations...${NC}"
home-manager switch --flake ~/home_env_dotfiles-ML4W/#default --impure -b backup

echo -e "${GREEN}🎉 Upgrade complete! All GUI tools and ML4W configurations are now up-to-date!${NC}"
