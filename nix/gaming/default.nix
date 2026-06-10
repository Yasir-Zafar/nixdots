{pkgs, ...}: {
  imports = [
    ./steam.nix
    ./performance.nix
    # ./retroarch.nix
  ];

  environment.systemPackages = with pkgs; [
    winetricks
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav

    protonup-qt
    protontricks

    heroic
    prismlauncher
    lunar-client
    cartridges

    dolphin-emu

    gnome-mahjongg
    gnome-chess
    gnome-2048
    gnome-mines
    gnome-sudoku
    aisleriot
  ];

  users.users.boi.extraGroups = ["docker"];
}
