{pkgs, ...}: {
  home.packages = with pkgs; [
    nautilus

    mission-center
    powertop

    gnome-feeds

    protonvpn-gui

    gearlever
    libnotify
    gnome-decoder
    impression
  ];
}
