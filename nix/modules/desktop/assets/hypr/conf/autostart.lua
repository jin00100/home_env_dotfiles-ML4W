hl.on("hyprland.start", function () 
    -- Load cursor
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 24")
    -- Start listeners
    hl.exec_cmd("~/.config/ml4w/listeners.sh --startall")
    -- Start polkit daemon
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    -- Restore wallpaper
    hl.exec_cmd("~/.config/ml4w/scripts/ml4w-wallpaper-app --restore")
    -- Environment for xdg-desktop-portal-hyprland
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user restart xdg-desktop-portal-hyprland xdg-desktop-portal sunshine")
    -- Autostart scripts
    hl.exec_cmd("~/.config/ml4w/scripts/ml4w-autostart")
    -- Load GTK settings
    hl.exec_cmd("~/.config/hypr/scripts/gtk.sh")
    -- Start swaync
    hl.exec_cmd("swaync")
    -- Start hypridle
    hl.exec_cmd("hypridle")
    -- Load cliphist history
    hl.exec_cmd("wl-paste --watch cliphist store")
    -- Start fcitx5 input method
    hl.exec_cmd("fcitx5 -d --replace")
    -- Start autostart cleanup
    hl.exec_cmd("~/.config/hypr/scripts/cleanup.sh")
    -- Start Chameleon Engine (Wallpaper Automation)
    hl.exec_cmd("sh -c 'rm -f ~/.cache/ml4w/hyprland-dotfiles/wallpaper-automation && ~/.config/ml4w/scripts/ml4w-wallpaper-automation'")
end)