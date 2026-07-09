{
  description = "Stage 1 Nix Home Manager configuration for ML4W Hyprland Dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    smoothcursor = {
      url = "github:gen740/smoothcursor.nvim";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      mkHomeConfig = username: system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          extraSpecialArgs = {
            inherit inputs username;
          };
          modules = [ ./nix/home.nix ];
        };

      currentUsername = builtins.getEnv "USER";

    in {
      homeConfigurations = nixpkgs.lib.genAttrs [ currentUsername ] (username:
        mkHomeConfig username "x86_64-linux"
      );
    };
}
