# Noctalia bar/shell. Settings live in noctalia.toml (Noctalia's own format, so an export
# from its Settings can be pasted in); only the asset paths are filled in here. The folder
# is the live repo checkout, not the store, so new wallpapers show up without a rebuild.
{
  lib,
  my,
  ...
}: let
  assets = "${my.home}/dots/assets";
  wallpaper = "${assets}/2.jpg";
in {
  programs.noctalia = {
    enable = true;

    settings = lib.recursiveUpdate (lib.importTOML ./noctalia.toml) {
      shell.avatar_path = "${assets}/profile.jpg";
      wallpaper = {
        directory = assets;
        fill_mode = "span";
        default.path = wallpaper;
        last.path = wallpaper;
        monitors.eDP-1.path = wallpaper;
      };
    };
  };
}
