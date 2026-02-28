# nixos/users/default.nix
# User account configuration
{pkgs, ...}: {
  imports = [
    ./username.nix # User-specific configuration
  ];

  # ============================================================================
  # User Account Definition
  # ============================================================================
  users.users.boi = {
    isNormalUser = true;
    description = "Yasir Zafar";

    # User groups (permissions)
    extraGroups = [
      "wheel" # Sudo/doas privileges
      "networkmanager" # Network management
      "audio" # Audio devices
      "video" # Video devices (cameras, GPUs)
      "input" # Input devices (keyboard, mouse)
      "storage" # Storage devices (USB drives)
      "gamemode" # GameMode optimization
      "libvirtd"
      "libvirt"
      "kvm"
      "wireshark"

      # Additional groups to consider:
      # "docker"                                        # Already in gaming/default.nix
      # "libvirtd"                                      # Virtual machines
      # "scanner"                                       # Scanner access
      # "lp"                                            # Printer access
    ];

    # Default shell
    shell = pkgs.zsh;

    # Optional: Set initial password (change after first login!)
    # initialPassword = "changeme";

    # Optional: User-specific packages (most should go in Home Manager)
    # packages = with pkgs; [
    #   # System-level user packages only
    # ];
  };

  # ============================================================================
  # Shell Configuration
  # ============================================================================
  # Enable Zsh system-wide
  programs.zsh = {
    enable = true;
  };

  # ============================================================================
  # Additional User Management
  # ============================================================================
  # Optional: Default user shell for all users
  users.defaultUserShell = pkgs.zsh;
}
