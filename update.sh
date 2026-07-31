#!/usr/bin/env bash
set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 1. 动态获取脚本所在目录（彻底解决路径写死导致崩溃的问题）
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo -e "${BLUE}🚀 Fetching the latest global tool versions from Nixpkgs (nix flake update)...${NC}"
nix flake update

# 2. GitOps 自动锁定机制
if git diff --name-only | grep -q "flake.lock"; then
    echo -e "${YELLOW}📦 Detected flake.lock changes. Auto-committing to Git for GitOps rollback safety...${NC}"
    git add flake.lock
    git commit -m "chore(nix): auto-update flake.lock versions"
fi

echo -e "${BLUE}🔄 Applying the latest GUI versions and hot-reloading configurations...${NC}"
# 3. 使用相对路径进行编译
home-manager switch --flake ".#$USER" --impure -b backup

echo -e "${GREEN}🎉 Upgrade complete! All GUI tools and ML4W configurations are now up-to-date!${NC}"
