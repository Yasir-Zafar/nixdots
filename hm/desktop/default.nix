{pkgs, ...}: {
  imports = [
    ./gnome-settings.nix
    ./qt.nix
    ./niri-config.nix
    ./noctal.nix
  ];

  home.packages = with pkgs; [
    nwg-look
    sassc
    gnome-themes-extra
    gtk-engine-murrine

    bibata-cursors

    nautilus-open-any-terminal
    qpdf
  ];
}
