{pkgs, ...}: {
  imports = [
    # ./gnome-settings.nix
    # ./qt.nix
    ./niri-config.nix
  ];

  home.packages = with pkgs; [
    fuzzel

    nwg-look
    sassc
    gnome-themes-extra
    gtk-engine-murrine

    bibata-cursors

    nautilus-open-any-terminal
    qpdf
  ];
}
