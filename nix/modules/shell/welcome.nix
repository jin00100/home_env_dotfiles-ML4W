{ config, pkgs, lib, ... }:

{
  programs.zsh.initContent = lib.mkMerge [
    ''
      # ---------------------------------------------------------
      # [SSH Only] Welcome Message & Branding
      # Local terminals under Hyprland / Niri will NOT show logo
      # ---------------------------------------------------------
      if is_ssh; then
        # Disable line wrapping
        printf "\e[?7l"

        # Fast OS detection
        local os_name="Linux"
        if [[ -f /etc/os-release ]]; then
          os_name=$(grep PRETTY_NAME /etc/os-release | cut -d '"' -f2)
        fi

        # SSH: Always show the small version with Gemini gradient
        echo ""
        echo -e "[38;2;66;133;244m███████████████████╗   ██████████╗  ██╗   [0m"
        echo -e "[38;2;90;117;240m╚══██╔══██╔═════████╗  ██╚════███║  ██║   [0m"
        echo -e "[38;2;114;102;235m   ██║  █████╗  ██╔██╗ ██  ██████║  ██║   [0m"
        echo -e "[38;2;138;86;231m   ██║  ██╔══╝  ██║╚██╗██  ╚══███║  ██║   [0m"
        echo -e "[38;2;161;71;226m   ██║  ██████████║ ╚████████████████████╗[0m"
        echo -e "[38;2;185;55;222m   ╚═╝  ╚═══════╚═╝  ╚═══╚═══════╚═══════╝[0m"
        echo ""

        # System info colors
        echo -e "[1;31m $os_name[0m"
        echo -e "[1;33m HOST      : $(uname -n)[0m"
        local session_title="Zellij (Modern Terminal Workspace)"
        if [[ "$XDG_CURRENT_DESKTOP" == "niri" ]] || pgrep -u "$USER" -x niri >/dev/null 2>&1; then
          session_title="iNiR / Niri"
        elif [[ "$XDG_CURRENT_DESKTOP" == "Hyprland" ]] || pgrep -u "$USER" -x Hyprland >/dev/null 2>&1; then
          session_title="Hyprland (ML4W)"
        fi
        echo -e "[1;32m SESSION   : $session_title[0m"
        echo -e "[1;34m Kernel    : $(uname -r)[0m"
        echo -e "[1;35m Date      : $(date +'%Y-%m-%d %H:%M:%S')[0m"
        echo -e "[1;36m Shell     : $(zsh --version | awk '{print $1, $2}')[0m"
        echo -e "[1;37m Who       : $(whoami)[0m"

        echo -e "
Welcome to [94mZsh[0m, [1m$USER![0m"

        # Re-enable line wrapping
        printf "\e[?7h"
      fi      
    ''
  ];
}
