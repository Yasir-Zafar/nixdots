# nixos/configuration.nix
# Main system configuration - imports all other modules
{pkgs, ...}: {
  # ============================================================================
  # Module Imports
  # ============================================================================
  imports = [
    ./hardware # Hardware-specific configuration
    ./boot # Boot loader and kernel settings
    ./desktop # Desktop environment (GNOME)
    ./gaming # Gaming-related packages and settings
    ./development # Development tools and environments
    ./users # User accounts and permissions
    ./security # Security hardening and firewall
    ./services # System services (Apache, MySQL, etc.)
  ];

  # ============================================================================
  # Essential System Packages
  # ============================================================================
  environment.systemPackages = with pkgs; [
    vim # Text editor (consider adding neovim as well)
    wineWowPackages.stable # Windows compatibility layer (64-bit + 32-bit)
    gnome-firmware # Firmware updater for GNOME
    fuse
    fuse3
  ];
  programs.nix-ld.enable = true;
  programs = {
    appimage = {
      enable = true;
      binfmt = true;
      package = pkgs.appimage-run.override {
        extraPkgs = pkgs: [pkgs.xorg.libxshmfence];
      };
    };
  };

  # ============================================================================
  # Nix Configuration
  # ============================================================================
  nix.settings = {
    # Enable experimental features
    experimental-features = ["nix-command" "flakes"];

    # Optional: Auto-optimize nix store
    auto-optimise-store = true;
  };

  # ============================================================================
  # Package Configuration
  # ============================================================================
  nixpkgs.config.allowUnfree = true;

  # ============================================================================
  # System State Version
  # ============================================================================
  # DO NOT CHANGE - This determines the NixOS version you originally installed
  # See https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "25.05";
}
