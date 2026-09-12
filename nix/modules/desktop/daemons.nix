{ config, pkgs, ... }:

let
  qsRunner = pkgs.writeShellScript "ml4w-qs-runner" ''
    export PATH="$HOME/.nix-profile/bin:$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:$PATH"
    export QT_QUICK_BACKEND=software
    export XDG_DATA_DIRS="$HOME/.local/share:$HOME/.nix-profile/share:''${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
    QS_BIN="$(([ -x /usr/bin/qs ] && echo "/usr/bin/qs") || ([ -x /usr/bin/quickshell ] && echo "/usr/bin/quickshell") || command -v qs 2>/dev/null || command -v quickshell 2>/dev/null || echo "${pkgs.quickshell}/bin/qs")"
    exec "$QS_BIN" "$@"
  '';
in
{
  systemd.user.services = {
    ml4w-quickshell = {
      Unit = {
        Description = "ML4W Quickshell Base Daemon (Sidebar & Power Menu)";
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecCondition = "${pkgs.bash}/bin/bash -c '[ \"$XDG_CURRENT_DESKTOP\" = \"Hyprland\" ]'";
        ExecStart = "${qsRunner}";
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
        ExecStart = "${qsRunner} -p %h/.config/quickshell/overview";
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
        ExecStart = "${qsRunner} -p %h/.local/share/ml4w-dotfiles-settings/quickshell";
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
