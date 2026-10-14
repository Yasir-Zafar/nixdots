{pkgs, ...}: {
  imports = [
    ./steam.nix
    ./performance.nix
    # ./retroarch.nix
  ];

  environment.systemPackages = with pkgs; [
    winetricks

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
