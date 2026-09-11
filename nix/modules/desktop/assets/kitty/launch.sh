#!/usr/bin/env bash
KITTY_BIN="$(command -v kitty)"

if [[ "$KITTY_BIN" == /nix/store/* ]] && command -v nixGL &>/dev/null; then
    exec nixGL kitty "$@"
else
    exec "$KITTY_BIN" "$@"
fi
