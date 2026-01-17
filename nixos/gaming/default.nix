# nixos/gaming/default.nix
{pkgs, ...}: {
  imports = [
    ./steam.nix
    ./performance.nix
    ./retroarch.nix
  ];

  environment.systemPackages = with pkgs; [
    gamemode

    bottles
    winetricks
    lutris
    protonup-qt
    docker
    protontricks

    # Gaming & Emulation
    prismlauncher
    lunar-client
    heroic
    dolphin-emu

    cartridges
    gnome-mahjongg
    gnome-chess
    gnome-2048
    gnome-klotski
    gnome-nibbles
    gnome-mines
    gnome-sudoku
    gnome-taquin
  ];

  # In /etc/nixos/configuration.nix
  virtualisation.docker = {
    enable = true;
  };

  # Optional: Add your user to the "docker" group to run docker without sudo
  users.users.boi.extraGroups = ["docker"];
}
