{pkgs, ...}: {
  home.packages = with pkgs; [
    nautilus

    mission-center
    powertop

    gnome-feeds

    p7zip
    unrar

    protonvpn-gui

    gearlever
    libnotify
    gnome-decoder
    impression
  ];
}
