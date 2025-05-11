# home/system/cursor.nix
{ config, lib, pkgs, ... }:

{
  # Mouse cursor configuration
  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
  };

  # Install cursor themes
  home.packages = with pkgs; [
    bibata-cursors
    capitaine-cursors
    numix-cursor-theme
    nordzy-cursor-theme
  ];

  # Make sure settings are also applied to Wayland
  home.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
  };
}
