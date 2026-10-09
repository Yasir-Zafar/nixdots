{pkgs, ...}: {
  imports = [
    #./gnome-settings.nix
    ./stylix.nix
    ./qt.nix
    ./niri-config.nix
    ./noctalia.nix
    ./nixcord.nix
  ];

  home.packages = with pkgs; [
    nwg-look
    bibata-cursors
  ];
}
