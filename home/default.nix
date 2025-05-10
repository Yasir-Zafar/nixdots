# home/default.nix
{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    # Import system settings
    ./system
    
    # Import app/program configurations 
    ./programs
    
    # Import settings
    ./settings
    
    # Import services
    ./services
    
    # Import scripts
    ./scripts
    
    # Import files
    ./files
  ];

  # Home Manager configuration
  home = {
    # Environment variables
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      TERMINAL = "kitty";
      #BROWSER = "firefox";
      MOZ_ENABLE_WAYLAND = 1;
      QT_QPA_PLATFORM = "wayland";
      QT_QPA_PLATFORMTHEME = "qt5ct";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
      SDL_VIDEODRIVER = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = 1;
      CLUTTER_BACKEND = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      GDK_BACKEND = "wayland";
    };
    
    # State version - update only when needed
    stateVersion = "24.05";
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
  
  # Enable fontconfig
  fonts.fontconfig.enable = true;
  
  # Enable cachix
  caches = {
    hyprland = {
      name = "hyprland";
      url = "https://hyprland.cachix.org";
      pubKey = "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=";
    };
    nix-community = {
      name = "nix-community";
      url = "https://nix-community.cachix.org";
      pubKey = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
    };
    nixpkgs-wayland = {
      name = "nixpkgs-wayland";
      url = "https://nixpkgs-wayland.cachix.org";
      pubKey = "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA=";
    };
  };
}
