{ config, pkgs, lib, ... }:

{
  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];

  home.packages = with pkgs; [
    # [System Utils & CLI Tools]
    wget
    curl
    gum
    jq
    btop
    ripgrep
    fd
    unzip
    rsync
    inotify-tools
    xclip
    wl-clipboard
    eza
    bat
    fastfetch
    figlet
    htop
    fzf
    libnotify
    
    # [Ported & Modern Rust Utils]
    lazygit
    lolcat
    lsb-release
    xsel
    ncdu
    duf
    tldr
    yq-go
    fnm
    
    # [DevOps & Nix Native Tools added via optimization]
    procs
    gping
    dust
    nix-output-monitor
    nix-index
    nix-tree
    rclone
  ];
}
