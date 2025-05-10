{
  description = "NixOS System Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # For hardware support
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    
    # For flake management
    flake-utils.url = "github:numtide/flake-utils";
    
    # For Hyprland
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, hyprland, flake-utils, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      
      # Library functions 
      lib = nixpkgs.lib;
      
    in {
      nixosConfigurations = {
        dpix720 = lib.nixosSystem {
          inherit system;
          modules = [
            # Core configuration
            ./hosts/dpix720
            
            # Hardware configurations
            ./hardware/default.nix
            
            # Other main modules
            ./settings
            ./programs
            ./userspace
            ./services
            
            # Hyprland module
            hyprland.nixosModules.default
            
            # Always include cachix
            ({ pkgs, ... }: {
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
                  trusted-users = [ "root" "@wheel" ];
                  auto-optimise-store = true;
                  experimental-features = [ "nix-command" "flakes" ];
                };
                gc = {
                  automatic = true;
                  dates = "weekly";
                  options = "--delete-older-than 30d";
                };
              };
            })
          ];
          specialArgs = { inherit inputs; };
        };
      };
    };
}
