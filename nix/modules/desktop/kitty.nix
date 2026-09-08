{ pkgs, ... }:

{
  # theme.nix copies the writable ML4W Kitty configuration.  Keep this module
  # responsible only for installing the executable, so Home Manager does not
  # generate a competing ~/.config/kitty/kitty.conf.
  # Prefer host-installed kitty (pacman) for native NVIDIA OpenGL/EGL support
  home.packages = [];
}
