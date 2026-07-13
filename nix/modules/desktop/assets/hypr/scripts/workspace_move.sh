#!/usr/bin/env bash
MONITOR=$(hyprctl activeworkspace -j | jq -r '.monitor')
TARGET=$1

if [ "$MONITOR" = "DP-2" ]; then
    if [ "$TARGET" -le 5 ]; then
        let "TARGET = TARGET + 5"
    fi
else
    if [ "$TARGET" -ge 6 ]; then
        let "TARGET = TARGET - 5"
    fi
fi

hyprctl dispatch "hl.dsp.window.move({workspace = \"$TARGET\"})"
