{ config, pkgs, ... }:

{
  systemd.user.services = {
    ml4w-quickshell = {
      Unit = {
        Description = "ML4W Quickshell Base Daemon (Sidebar & Power Menu)";
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Environment = "QT_QUICK_BACKEND=software";
        ExecStart = "%h/.nix-profile/bin/qs";
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
        Environment = "QT_QUICK_BACKEND=software";
        ExecStart = "%h/.nix-profile/bin/qs -p %h/.config/quickshell/overview";
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
        Environment = [
          "QT_QUICK_BACKEND=software"
          "PROFILE=com.ml4w.dotfiles"
        ];
        ExecStart = "%h/.nix-profile/bin/qs -p %h/.local/share/ml4w-dotfiles-settings/quickshell";
        Restart = "always";
        RestartSec = 2;
      };
      Install = { WantedBy = [ "graphical-session.target" ]; };
    };
  };
}
