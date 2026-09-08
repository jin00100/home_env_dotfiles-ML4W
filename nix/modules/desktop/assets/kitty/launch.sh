#!/usr/bin/env bash
if command -v nixGL &>/dev/null; then
    exec nixGL kitty "$@"
else
    exec kitty "$@"
fi
