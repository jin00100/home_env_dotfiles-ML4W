{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # [GUI & Desktop Components]
    waybar
    rofi
    wlogout
    waypaper
    nwg-look
    nwg-dock-hyprland
    nwg-displays
    qt6Packages.qt6ct
    qt6Packages.qt5compat
    pavucontrol
    blueman
    networkmanagerapplet
    swaynotificationcenter
    matugen

    # [Hyprland Utilities]
    hyprpaper
    hyprpicker
    brightnessctl
    pamixer
    grim
    slurp
    swappy
    cliphist
    udiskie
    swaybg
    imagemagick
    quickshell
    grimblast
    wayvnc
  ];
}
