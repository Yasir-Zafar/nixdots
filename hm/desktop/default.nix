# hm/desktop/default.nix
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./gnome-settings.nix
    ./gtk.nix
    ./qt.nix
  ];

  # Desktop packages
  home.packages = with pkgs; [
    # System monitoring
    htop
    btop

    # File management
    nautilus-open-any-terminal
  ];
}
