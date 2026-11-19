# Noctalia bar/shell. Settings live in noctalia.toml (Noctalia's own format, so an export
# from its Settings can be pasted in); only the paths are filled in here.
#
# Wallpapers: ~/Pictures/Wallpapers is a normal folder. The repo's wallpapers (assets/)
# are linked into it, as links to the live checkout (not the store), so a new file in
# assets/ only needs to be added to the list below. Files you drop into the folder
# yourself are left alone and show up in Noctalia's wallpaper picker as well.
{
  config,
  lib,
  my,
  ...
}: let
  assets = "${my.home}/dots/assets";
  folder = "${config.home.homeDirectory}/Pictures/Wallpapers";
  # wall.jpg is the same picture as 2.jpg (bspwm and lightdm use that name)
  repoWallpapers = ["TeachInvadersGruvbox.png" "2.jpg" "desktop.png"];
  wallpaper = "${folder}/TeachInvadersGruvbox.png";
in {
  home.file = lib.listToAttrs (map (name: {
      name = "Pictures/Wallpapers/${name}";
      value.source = config.lib.file.mkOutOfStoreSymlink "${assets}/${name}";
    })
    repoWallpapers);

  programs.noctalia = {
    enable = true;

    settings = lib.recursiveUpdate (lib.importTOML ./noctalia.toml) {
      shell.avatar_path = "${assets}/profile.jpg";
      wallpaper = {
        directory = folder;
        fill_mode = "span";
        default.path = wallpaper;
        last.path = wallpaper;
        monitors.eDP-1.path = wallpaper;
      };
    };
  };
}
