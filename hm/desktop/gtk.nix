# hm/desktop/gtk.nix
{
  config,
  pkgs,
  ...
}: {
  # GTK configuration
  gtk = {
    enable = true;

    # theme = {
    #   name = "Gruvbox-Green-Dark-Soft";
    #   package = pkgs.gruvbox-gtk-theme;
    # };
    #
    # iconTheme = {
    #   name = "Gruvbox-Light";
    #   package = pkgs.gruvbox-gtk-theme;
    # };

    # cursorTheme = {
    #   name = "Bibata-Modern-Classic";
    #   package = pkgs.bibata-cursors;
    # };
    #
    # font = {
    #   name = "Inter";
    #   size = 11;
    # };
  };

  # Dark theme for applications
  # home.sessionVariables = {
  #   GTK_THEME = "Adwaita:dark";
  # };
}
