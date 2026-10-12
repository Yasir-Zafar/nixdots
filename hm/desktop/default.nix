{pkgs, ...}: {
  imports = [
    #./gnome-settings.nix
    ./stylix.nix
    ./qt.nix
    ./niri-config.nix
    ./noctalia.nix
  ];

  home.packages = with pkgs; [
    nwg-look
    bibata-cursors
  ];
}
