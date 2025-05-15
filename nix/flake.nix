{
  description = "NixOS System Configuration";
  nixConfig = {
    # Cachix binary caches
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
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # For hardware support
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # For flake management
    flake-utils.url = "github:numtide/flake-utils";

    # For Hyprland
    hyprland.url = "github:hyprwm/Hyprland";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";

    nix-software-center.url = "github:snowfallorg/nix-software-center";
  };
  outputs = {
    nixpkgs,
    hyprland,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem
    (system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      packages.default = pkgs.hello;
    })
    // {
      nixosConfigurations.dpix720 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs hyprland;
        };
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
          {nixpkgs.overlays = [inputs.hyprpanel.overlay];}
        ];
      };
    };
}
