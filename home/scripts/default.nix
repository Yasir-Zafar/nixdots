{ config, lib, pkgs, ... }:

{
  home.file.".local/bin/wallpaper-rotator.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
      DELAY=300  # 5 minutes

      pgrep -x swww > /dev/null || swww-deamon

      while true; do
        find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) | shuf | while read -r img; do
          swww img "$img" --transition-type fade --transition-duration 2
          sleep "$DELAY"
        done
      done
    '';
  };
}
