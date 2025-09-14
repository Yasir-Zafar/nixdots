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
  ];
}
