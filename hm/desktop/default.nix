{pkgs, ...}: {
  imports = [
    ./gnome-settings.nix
    ./qt.nix
    ./niri-config.nix
    ./noctal.nix
    ./nixcord.nix
  ];

  home.packages = with pkgs; [
    nwg-look
    sassc
    gnome-themes-extra
    gtk-engine-murrine
    gnome-notes

    bibata-cursors

    nautilus-open-any-terminal
    qpdf
  ];
}
