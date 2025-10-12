# ===== hm/applications/utilities.nix =====
{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # Virtual machine
    gnome-boxes

    # File managers
    nautilus

    # Calculator and productivity
    gnome-calculator

    # System Tools
    pavucontrol
    mission-center
    btop
    htop

    # Utilities
    protonvpn-gui
    gearlever
    parabolic
    fragments
    pinta
    aria2

    # Optional dependencies
    gnome-epub-thumbnailer
  ];
}
