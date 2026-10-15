# GTK theme and icon packages built from the repo's assets/, shared by home (desktop/gtk.nix)
# and the lightdm greeter. The name must match the folder under share/themes|icons.
{
  pkgs,
  my,
}: let
  themeName = "Gruvbox-Green-Dark-Medium";
  iconName = "Gruvbox-Plus-Dark";
in {
  theme = {
    name = themeName;
    package = pkgs.runCommand "gruvbox-gtk-theme" {} ''
      mkdir -p $out/share/themes
      cp -a ${my.assets + "/${themeName}"} $out/share/themes/${themeName}
    '';
  };

  icons = {
    name = iconName;
    package = pkgs.runCommand "gruvbox-plus-icons" {} ''
      mkdir -p $out/share/icons
      cp -a ${my.assets + "/${iconName}"} $out/share/icons/${iconName}
    '';
  };
}
