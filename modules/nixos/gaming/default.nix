{pkgs, ...}: {
  imports = [
    ./steam.nix
    ./performance.nix
    # ./retroarch.nix
  ];

  environment.systemPackages = with pkgs; [
    winetricks
    mangohud # overlay: steam launch options `mangohud %command%`

    heroic
    prismlauncher
    lunar-client

    dolphin-emu

    gnome-mahjongg
    gnome-chess
    gnome-2048
    gnome-mines
    gnome-sudoku
    aisleriot
  ];
}
