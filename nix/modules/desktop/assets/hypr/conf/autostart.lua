hl.on("hyprland.start", function () 
    -- Load cursor
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 24")
    -- Start listeners
    hl.exec_cmd("~/.config/ml4w/listeners.sh --startall")
    -- Start polkit-gnome authentication agent (supports Arch & Debian/Ubuntu)
    hl.exec_cmd([=[bash -c 'for agent in /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1; do if [ -f "$agent" ]; then exec env -u GDK_PIXBUF_MODULE_FILE -u GIO_EXTRA_MODULES GDK_BACKEND=x11 "$agent"; fi; done']=])
    -- Restore wallpaper
    hl.exec_cmd("~/.config/ml4w/scripts/ml4w-wallpaper-app --restore")
    -- Give user services the current Wayland session before starting them.
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_DESKTOP")
    hl.exec_cmd("systemctl --user restart fcitx5.service")
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
    -- Pre-warm Nautilus file manager in background for instantaneous Super+E opening
    hl.exec_cmd("env NAUTILUS_PERSIST=1 nautilus --gapplication-service")
    -- Start autostart cleanup
    hl.exec_cmd("~/.config/hypr/scripts/cleanup.sh")
    -- Start Chameleon Engine (Wallpaper Automation)
    hl.exec_cmd("rm -f ~/.cache/ml4w/hyprland-dotfiles/wallpaper-automation && ~/.config/ml4w/scripts/ml4w-wallpaper-automation")
end)