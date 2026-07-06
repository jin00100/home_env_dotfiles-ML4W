{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    ayu-theme-gtk
    papirus-icon-theme
    bibata-cursors
  ];

  gtk = {
    enable = true;
    theme = {
      name = "Ayu-Dark";
      package = pkgs.ayu-theme-gtk;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.theme = config.gtk.theme;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 52;
    };
    font = {
      name = "Maple Mono NF";
      size = 11;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 52;
  };

  # Copy dotfiles to ~/.config on activation to keep them writable for tools like matugen
  home.activation.copyDotfiles = lib.hm.dag.entryAfter ["writeBoundary"] ''
    copyConfig() {
      src="$1"
      dest="$HOME/.config/$2"
      
      # Backup user-modified files to prevent them from being wiped out
      backup_dir=$(mktemp -d)
      if [ -d "$dest" ]; then
        if [ "$2" = "hypr" ]; then
          for f in monitors.lua colors.conf colors.lua custom.lua; do
            if [ -f "$dest/$f" ]; then
              cp "$dest/$f" "$backup_dir/$f"
            fi
          done
        elif [ "$2" = "ml4w" ]; then
          if [ -d "$dest/settings" ]; then
            cp -r "$dest/settings" "$backup_dir/settings"
          fi
          if [ -d "$dest/wallpapers" ]; then
            cp -r "$dest/wallpapers" "$backup_dir/wallpapers"
          fi
        fi
      fi

      if [ -L "$dest" ]; then
        rm "$dest"
      fi
      tmp_dest="$dest.tmp"
      rm -rf "$tmp_dest"
      cp -r "$src" "$tmp_dest"
      chmod -R u+w "$tmp_dest"
      
      # Restore backed-up user files
      if [ -d "$backup_dir" ]; then
        if [ "$2" = "hypr" ]; then
          for f in monitors.lua colors.conf colors.lua custom.lua; do
            if [ -f "$backup_dir/$f" ]; then
              cp "$backup_dir/$f" "$tmp_dest/$f"
            fi
          done
        elif [ "$2" = "ml4w" ]; then
          if [ -d "$backup_dir/settings" ]; then
            rm -rf "$tmp_dest/settings"
            cp -r "$backup_dir/settings" "$tmp_dest/settings"
          fi
          if [ -d "$backup_dir/wallpapers" ]; then
            cp -r "$backup_dir/wallpapers"/* "$tmp_dest/wallpapers/" 2>/dev/null || true
          fi
        fi
      fi
      rm -rf "$backup_dir"

      if [ ! -d "$dest" ]; then
        mv "$tmp_dest" "$dest"
      else
        # Use rsync to seamlessly update the directory contents without deleting the folder itself.
        # This prevents Hyprland from crashing or throwing a "file not found" error during the hot-swap.
        ${pkgs.rsync}/bin/rsync -a --delete "$tmp_dest/" "$dest/"
        rm -rf "$tmp_dest"
      fi
    }

    copyConfig "${./assets/hypr}" "hypr"
    copyConfig "${./assets/waybar}" "waybar"
    copyConfig "${./assets/rofi}" "rofi"
    copyConfig "${./assets/kitty}" "kitty"
    copyConfig "${./assets/swaync}" "swaync"
    copyConfig "${./assets/ml4w}" "ml4w"
    copyConfig "${./assets/nwg-dock-hyprland}" "nwg-dock-hyprland"
    copyConfig "${./assets/walker}" "walker"
    copyConfig "${./assets/quickshell}" "quickshell"
  '';

  # Static assets & settings that don't need runtime write access
  xdg.configFile = {
    "matugen".source = ./assets/matugen;
    "wlogout".source = ./assets/wlogout;
    "waypaper".source = ./assets/waypaper;
    "fastfetch".source = ./assets/fastfetch;
    "btop".source = ./assets/btop;
    "qt6ct".source = ./assets/qt6ct;
    "ml4w-dotfiles-settings".source = ./assets/ml4w-dotfiles-settings;
    "sidepad".source = ./assets/sidepad;
    "xsettingsd".source = ./assets/xsettingsd;
    "chromium-flags.conf".source = ./assets/chromium-flags.conf;
    "edge-flags.conf".source = ./assets/edge-flags.conf;
  };
}
