# GTK theme, icons and font from assets/ (not stylix's gtk target: it generates its own)
{
  config,
  pkgs,
  my,
  ...
}: let
  gruvbox = import ../../../lib/gruvbox-gtk.nix {inherit pkgs my;};
  inherit (config.stylix.fonts) sansSerif;
in {
  gtk = {
    enable = true;

    inherit (gruvbox) theme;
    # gtk4 ignores the theme name; HM imports its gtk.css, which needs the package
    gtk4.theme = config.gtk.theme;
    iconTheme = gruvbox.icons;
    colorScheme = "dark";

    # same cursor as stylix (it leaves home.pointerCursor.gtk off)
    cursorTheme = {
      inherit (config.stylix.cursor) name package size;
    };

    font = {
      inherit (sansSerif) name package;
      size = 12;
    };

    gtk3.extraConfig = {
      gtk-decoration-layout = "menu:close";
      gtk-enable-animations = true;
      gtk-primary-button-warps-slider = false;
    };

    gtk4.extraConfig = {
      gtk-decoration-layout = "menu:close";
    };
  };
}
