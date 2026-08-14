{pkgs, ...}: {
  imports = [
    #./gnome-settings.nix
    ./qt.nix
    ./niri-config.nix
    ./noctal.nix
    ./nixcord.nix
  ];

  home.packages = with pkgs; [
    nwg-look
    bibata-cursors
  ];
}
