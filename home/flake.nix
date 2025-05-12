{
  description = "Home Manager Flake with Hyprland and Cachix";

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    hyprland.url = "github:hyprwm/Hyprland";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";  # Add this as a flake input
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, hyprland, ... }@inputs: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      homeConfigurations = {
        boi = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./default.nix
            {
	      home = {
                username = "boi";
                homeDirectory = "/home/boi";
		stateVersion = "24.11";
	      };
              programs.home-manager.enable = true;

              nix.package = pkgs.nix;
              nixpkgs.config.allowUnfree = true;
              _module.args = {
                inherit inputs;
                # You can also export individual inputs if needed
                inherit hyprland;
              };
            }
          ];
          # You can also pass extraSpecialArgs to make inputs available
          extraSpecialArgs = { 
            inherit inputs;
          };
        };
      };
    };
}

