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

    # Gaming & Emulation
    prismlauncher
    lunar-client
    # dolphin-emu

    cartridges
    gnome-mahjongg
    gnome-chess
    gnome-2048
  ];
}
