{pkgs, ...}: {
  home.packages = with pkgs; [
    nautilus

    mission-center
    powertop

    gnome-feeds
    gdm-settings

    proton-vpn

    gearlever
    libnotify
    gnome-decoder
    impression
  ];
}
