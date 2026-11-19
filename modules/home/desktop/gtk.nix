# GTK theme and font from the repo's assets/, icons from Papirus (what nwg-look
# used to do by hand): settings.ini for gtk3/4, .gtkrc-2.0, gsettings (dconf) and the
# gtk4 css import all come from home-manager's gtk module. Not stylix's gtk target: that
# generates its own theme instead of this one.
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
    # libadwaita/gtk4 ignore the theme name; home-manager imports the theme's gtk.css
    # instead, which needs the package. Explicit so it survives the stateVersion bump.
    gtk4.theme = config.gtk.theme;
    # Papirus (wide app coverage, so the icons in nautilus and noctalia's bar match) with
    # orange folders for the gruvbox accent; `color` takes any papirus-folders colour.
    # The Gruvbox-Plus-Dark set stays in assets/ (lib/gruvbox-gtk.nix): swap back to
    # `gruvbox.icons` to use it again.
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme.override {color = "orange";};
    };
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
