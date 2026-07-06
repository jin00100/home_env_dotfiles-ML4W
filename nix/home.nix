{ config, pkgs, username, ... }:

{
  # [User Info - Dynamically passing from flake.nix]
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11"; 

  # [Module Loader] Load feature-specific files
  imports = [
    ./modules/core/system-utils.nix
    ./modules/core/fonts.nix
    ./modules/dev/dev-tools.nix
    ./modules/desktop/gui-apps.nix
    ./modules/desktop/hyprland.nix
    ./modules/desktop/theme.nix
    ./modules/desktop/wayvnc.nix

    # --- Ported Shell Environment ---
    ./modules/shell/shell.nix
    ./modules/shell/bash.nix
    ./modules/shell/nushell.nix

    # --- Ported Dev Environment ---
    ./modules/dev/neovim.nix
    ./modules/dev/zellij.nix
    ./modules/dev/git.nix

    # --- Ported Terminals ---
    ./modules/desktop/ghostty.nix
  ];

  targets.genericLinux.enable = true;
  fonts.fontconfig.enable = true;

  # [Auto GC] Automatically clean up unused Nix histories weekly
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  home.shellAliases = {
    # Kubernetes & Helm Shortcuts
    k = "kubectl";
    h = "helm";

    ls = "eza";
    ll = "eza -l --icons --git -a";
    lt = "eza --tree --level=2 --long --icons --git";
    
    # cat -> bat mapping
    cat = "bat";
    
    # Git & short commands
    la = "ls -a";
    g = "git";
    v = "nvim";
    vi = "nvim";
    vim = "nvim";
    
    # Clipboard copy alias
    tocb = "xclip -selection clipboard";

    # Home Manager alias for fast rebuilds.
    # Uses the expected path for the new DevOps modular repository
    hms = "nix run home-manager/master -- switch --flake ~/home_env_dotfiles-ML4W/#${username} --impure -b backup";
    
    # Zellij aliases
    zj = "zellij";
    zj_shortcuts = ''echo -e "\033[1;34m=== Zellij Custom Shortcuts (Tmux Style) ===\033[0m" && echo -e "\033[1;33m[ Quick Actions (Alt Key) ]\033[0m" && echo "  Alt + n       : New Pane (Right)" && echo "  Alt + h/j/k/l : Move focus (Left/Down/Up/Right)" && echo "  Alt + i/o     : Move Tab (Prev/Next)" && echo "  Alt + =/-     : Resize Pane (Increase/Decrease)" && echo -e "\033[1;33m[ Core Modes (Prefix) ]\033[0m" && echo "  Ctrl + g      : LOCKED Mode (Essential for NeoVim!)" && echo "  Ctrl + s      : SCROLL/COPY Mode (Like tmux prefix + [)" && echo "                  -> v: Select, y/Enter: Copy" && echo "  Ctrl + p      : PANE Mode (Split, Resize, etc.)" && echo "  Ctrl + t      : TAB Mode (New, Rename, etc.)" && echo "  Ctrl + n      : RESIZE Mode" && echo "  Ctrl + o      : SESSION Mode" && echo "  Ctrl + q      : QUIT Zellij" && echo -e "\033[1;32mTip: Bottom bar changes based on these modes!\033[0m" '';

    # Nix cleanup alias
    nix-clean = "nix-env --delete-generations old && nix-store --gc";
  };

  home.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "ibus";
    QT_QUICK_BACKEND = "software";
  };

  programs.home-manager.enable = true;
}
