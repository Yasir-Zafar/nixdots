{
  description = "Home Manager Flake with Hyprland and Cachix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cache-action.url = "github:nix-community/nix-cache-action";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, hyprland, nix-cache-action, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        username = "boi"; # Replace this
      in {
        homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            ./default.nix

            ({ ... }: {
              home.username = username;
              home.homeDirectory = "/home/${username}";
              home.stateVersion = "24.05";

              programs.home-manager.enable = true;

              nix = {
                settings = {
                  substituters = [
                    "https://cache.nixos.org"
                    "https://hyprland.cachix.org"
                    "https://nix-community.cachix.org"
                  ];
                  trusted-public-keys = [
                    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                    "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
                    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                  ];
                  experimental-features = [ "nix-command" "flakes" ];
                };
              };
            })
          ];
        };
      });
}

