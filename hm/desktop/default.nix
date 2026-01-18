# hm/desktop/default.nix
{pkgs, ...}: {
  imports = [
    ./gnome-settings.nix
    # ./gtk.nix
    ./qt.nix
  ];

  # Desktop packages
  home.packages = with pkgs; [
    # System monitoring
    htop
    btop
    powertop

    nwg-look
    sassc
    gnome-themes-extra
    gtk-engine-murrine
    bibata-cursors

    # File management
    nautilus-open-any-terminal
  ];
}
