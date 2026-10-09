{pkgs, ...}: {
  home.packages = with pkgs; [
    nautilus
    ffmpegthumbnailer
    loupe
    papers
    gnome-text-editor

    mission-center
    powertop
    btop

    gnome-feeds
    gdm-settings

    proton-vpn

    (pkgs.gearlever.override {dwarfs = null;}) # only works if the package supports it
    gnome-decoder
    impression
    theclicker
    qbittorrent

    qpdf
  ];
}
