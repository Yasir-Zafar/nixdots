{pkgs, ...}: {
  home.packages = with pkgs; [
    nautilus

    mission-center
    powertop
    btop

    gnome-feeds
    gdm-settings

    proton-vpn

    gearlever
    libnotify
    gnome-decoder
    impression
    theclicker
    qbittorrent

    qpdf
  ];
}
