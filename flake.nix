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
      username = if currentUsername != "" then currentUsername else "arch";
      system = if builtins ? currentSystem then builtins.currentSystem else "x86_64-linux";

    in {
      homeConfigurations =
        let
          userConfigs = {
            # Dynamic target for current user and host system
            "${username}" = mkHomeConfig username system;
            # Explicit architecture targets
            "${username}@x86_64-linux" = mkHomeConfig username "x86_64-linux";
            "${username}@aarch64-linux" = mkHomeConfig username "aarch64-linux";
          };
          archFallback = if username != "arch" then {
            "arch" = mkHomeConfig "arch" system;
            "arch@x86_64-linux" = mkHomeConfig "arch" "x86_64-linux";
            "arch@aarch64-linux" = mkHomeConfig "arch" "aarch64-linux";
          } else {};
        in
          userConfigs // archFallback;
    };
}

