# Noctalia; settings in noctalia.toml (its own export format), paths filled in here
# assets/ wallpapers are linked into ~/Pictures/Wallpapers; new ones need `git add`
{
  config,
  lib,
  my,
  ...
}: let
  assets = "${my.home}/dots/assets";
  folder = "${config.home.homeDirectory}/Pictures/Wallpapers";
  # profile.jpg = avatar; wall.jpg = 2.jpg (the name bspwm/lightdm use)
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
