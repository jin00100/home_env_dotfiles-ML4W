#!/usr/bin/env bash
# -----------------------------------------------------
# Guard: nwg-dock-hyprland is exclusively for Hyprland
# -----------------------------------------------------
if [ "${XDG_CURRENT_DESKTOP,,}" != "hyprland" ] && [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    exit 0
fi

#    ___           __
#   / _ \___  ____/ /__
#  / // / _ \/ __/  '_/
# /____/\___/\__/_/\_\
#

DOCK_THEME="modern"
if [ -f $HOME/.config/ml4w/settings/dock-theme ]; then
    DOCK_THEME=$(cat $HOME/.config/ml4w/settings/dock-theme)
fi
echo ":: Using Dock Theme $DOCK_THEME"
echo ":: Dock Autohide $DOCK_AUTOHIDE"
if [ ! -f $HOME/.config/ml4w/settings/dock-disabled ]; then
    pkill -f "nwg-dock-hyprland "
    sleep 0.5
    if [ -f $HOME/.config/ml4w/settings/dock-autohide ]; then
        for monitor in $(hyprctl monitors -j | jq -r '.[].name'); do
            nwg-dock-hyprland -m -o $monitor -d -hd 60 -i 32 -w 5 -mb 10 -x -s themes/$DOCK_THEME/style.css -c "$HOME/.config/hypr/scripts/launcher.sh" &
        done
        wait
    else
        for monitor in $(hyprctl monitors -j | jq -r '.[].name'); do
            nwg-dock-hyprland -m -o $monitor -i 32 -w 5 -mb 10 -x -s themes/$DOCK_THEME/style.css -c "$HOME/.config/hypr/scripts/launcher.sh" &
        done
        wait
    fi
else
    pkill -f "nwg-dock-hyprland "
    echo ":: Dock disabled"
fi