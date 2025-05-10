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
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, flake-utils, hyprland, ... }@inputs:
    let
      # Define the supported systems
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      # Get the hostname
      hostname = "dpix720"; # Replace with your actual hostname
      # Username 
      username = "boi";
      # Helper function to generate configs for each system
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in {
      homeConfigurations = {
        # Simple configuration: username only
        "${username}" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            ./default.nix
            {
              home = {
                username = username;
                homeDirectory = "/home/${username}";
                stateVersion = "24.05";
              };
              programs.home-manager.enable = true;
            }
          ];
        };
        
        # Configuration with hostname: username@hostname
        "${username}@${hostname}" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            ./default.nix
            {
              home = {
                username = username;
                homeDirectory = "/home/${username}";
                stateVersion = "24.05";
              };
              programs.home-manager.enable = true;
            }
          ];
        };
      };
      
      # Additional packages and outputs
      packages = forAllSystems (system: {
        default = self.homeConfigurations."${username}@${hostname}".activationPackage;
      });
    };
}
