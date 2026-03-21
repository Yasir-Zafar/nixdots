{pkgs, ...}: {
  imports = [
    ./gnome-settings.nix
    ./qt.nix
  ];

  home.packages = with pkgs; [
    htop
    btop
    powertop

    nwg-look
    sassc
    gnome-themes-extra
    gtk-engine-murrine

    bibata-cursors

    nautilus-open-any-terminal
    qpdf
  ];
}
