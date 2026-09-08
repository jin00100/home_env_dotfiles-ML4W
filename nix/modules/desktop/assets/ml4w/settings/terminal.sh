#!/usr/bin/env bash
if command -v nixGL &>/dev/null; then
    exec nixGL kitty -e zsh "$@"
else
    exec kitty -e zsh "$@"
fi
