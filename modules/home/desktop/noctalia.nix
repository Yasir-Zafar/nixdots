# Noctalia bar/shell. Settings live in noctalia.toml (Noctalia's own format, so an export
# from its Settings can be pasted in); only the paths are filled in here.
#
# Wallpapers: ~/Pictures/Wallpapers is a normal folder. Every image in assets/ is linked
# into it (links to the live checkout, not the store); new files in assets/ need a
# `git add` before the next home switch, since flakes only see files git knows about.
# Files you drop into the folder yourself are left alone and show up in Noctalia's
# wallpaper picker as well.
{
  config,
  lib,
  my,
  ...
}: let
  assets = "${my.home}/dots/assets";
  folder = "${config.home.homeDirectory}/Pictures/Wallpapers";
  # profile.jpg is the avatar; wall.jpg is the same picture as 2.jpg (bspwm and lightdm
  # use that name)
  notWallpapers = ["profile.jpg" "wall.jpg"];
  isImage = name: lib.any (ext: lib.hasSuffix ext (lib.toLower name)) [".png" ".jpg" ".jpeg" ".webp"];
  repoWallpapers = lib.attrNames (lib.filterAttrs (name: type:
    type == "regular" && isImage name && !(lib.elem name notWallpapers))
  (builtins.readDir my.assets));
  wallpaper = "${folder}/sunset.png";
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
