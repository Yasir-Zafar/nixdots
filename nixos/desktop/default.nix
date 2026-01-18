# nixos/desktop/default.nix
# Desktop environment and display manager configuration
{pkgs, ...}: {
  imports = [
    ./gnome.nix
    ./fonts.nix
  ];

  # ============================================================================
  # Display Manager Configuration
  # ============================================================================
  services.displayManager = {
    gdm = {
      enable = true;
      wayland = true; # Use Wayland for better performance
    };

    # Uncomment to enable auto-login (reduces security)
    # autoLogin = {
    #   enable = true;
    #   user = "boi";
    # };
  };

  # ============================================================================
  # XDG Desktop Portal
  # ============================================================================
  # Provides desktop integration for sandboxed apps (Flatpak, etc.)
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome # GNOME-specific portal
      xdg-desktop-portal-gtk # GTK fallback portal
    ];
  };

  # ============================================================================
  # Security Configuration
  # ============================================================================
  security = {
    polkit.enable = true; # Policy kit for privilege escalation
    pam.services.gdm.enableGnomeKeyring = true; # Integrate GNOME Keyring with GDM
  };

  services.usbguard.enable = false;

  # ============================================================================
  # Flatpak Support
  # ============================================================================
  services.flatpak.enable = true;

  # Optional: Disable unused TTY services (saves resources)
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
}
