{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # [Fonts]
    maple-mono.NF
    nerd-fonts.ubuntu-mono
    nerd-fonts.jetbrains-mono
    monaspace
  ];
}
