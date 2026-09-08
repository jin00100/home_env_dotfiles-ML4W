{ config, pkgs, ... }:

{
  systemd.user.services = {
    ml4w-quickshell = {
      Unit = {
        Description = "ML4W Quickshell Base Daemon (Sidebar & Power Menu)";
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecCondition = "${pkgs.bash}/bin/bash -c '[ \"$XDG_CURRENT_DESKTOP\" = \"Hyprland\" ]'";
        ExecStart = "/usr/bin/qs";
        Restart = "always";
        RestartSec = 2;
      };
      Install = { WantedBy = [ "graphical-session.target" ]; };
    };

    ml4w-quickshell-overview = {
      Unit = {
        Description = "ML4W Quickshell Overview Daemon";
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecCondition = "${pkgs.bash}/bin/bash -c '[ \"$XDG_CURRENT_DESKTOP\" = \"Hyprland\" ]'";
        ExecStart = "/usr/bin/qs -p %h/.config/quickshell/overview";
        Restart = "always";
        RestartSec = 2;
      };
      Install = { WantedBy = [ "graphical-session.target" ]; };
    };

    ml4w-quickshell-settings = {
      Unit = {
        Description = "ML4W Quickshell Settings Daemon";
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecCondition = "${pkgs.bash}/bin/bash -c '[ \"$XDG_CURRENT_DESKTOP\" = \"Hyprland\" ] && [ -d \"$HOME/.local/share/ml4w-dotfiles-settings/quickshell\" ]'";
        Environment = [
          "PROFILE=com.ml4w.dotfiles"
        ];
        ExecStart = "/usr/bin/qs -p %h/.local/share/ml4w-dotfiles-settings/quickshell";
        Restart = "always";
        RestartSec = 2;
      };
      Install = { WantedBy = [ "graphical-session.target" ]; };
    };

    fcitx5 = {
      Unit = {
        Description = "Fcitx5 input method";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "/usr/bin/fcitx5 --replace";
        Restart = "on-failure";
        RestartSec = 2;
      };
      Install = { WantedBy = [ "graphical-session.target" ]; };
    };
  };
}
