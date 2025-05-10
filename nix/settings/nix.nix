# settings/nix.nix
{ config, lib, pkgs, ... }:

{
  nix = {
    # Enable flakes and new commands
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "root" "@wheel" ];
      
      # Cachix binary caches
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      ];
      
      # Garbage collection settings
      keep-outputs = true;
      keep-derivations = true;
    };
    
    # Auto garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    
    # Optimize storage
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
    
    # Registry configuration
    registry = {
      nixpkgs.flake = pkgs.path;
    };
    
    # Run nix-daemon with low priority
    daemonIOSchedClass = "idle";
    daemonCPUSchedPolicy = "idle";
    
    # Allow unfree packages
    nixPath = [
      "nixpkgs=${pkgs.path}"
    ];
  };
  
  # Use latest nixpkgs for system packages
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = false;
    allowUnsupportedSystem = false;
    
    # Enable experimental features
    permittedInsecurePackages = [
      # Add any needed insecure packages here
    ];
  };
  
  # Optimization settings
  nixpkgs.overlays = [
    # Add any overlays here
  ];
  
  # Install nix utilities
  environment.systemPackages = with pkgs; [
    nix-index
    nix-prefetch-git
    nix-prefetch-github
    nix-update
    nixos-option
    nixpkgs-review
    cachix
    nix-top
  ];
  
  # Automatic upgrades
  system.autoUpgrade = {
    enable = false; # Set to true to enable auto-upgrades
    channel = "https://nixos.org/channels/nixos-unstable";
    dates = "04:00";
    randomizedDelaySec = "45min";
  };
}
