{ config, pkgs, ... }:

{
  home.packages = with pkgs; [

    # [LSP & Neovim Tools]
    tree-sitter
    nil
    ast-grep
    lua51Packages.jsregexp
    gopls
    clang-tools
    yaml-language-server
    bash-language-server
    dockerfile-language-server
  ];
}
