# ===== hm/applications/utilities.nix =====
{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
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
  ];
}
