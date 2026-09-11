#!/usr/bin/env bash
KITTY_BIN="$(command -v kitty)"

# 跨平台智能加速：若通过 Nix 安装在非 NixOS 上则使用 nixGL，其余情况（NVIDIA独显、核显、Mac）直通原生硬件加速
if [[ "$KITTY_BIN" == /nix/store/* ]] && command -v nixGL &>/dev/null; then
    exec nixGL kitty "$@"
else
    exec "$KITTY_BIN" "$@"
fi
