{ config, lib, pkgs, ... }:

{
  home.file.".local/bib/wallpaper-rotator.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      WALLPAPER_DIR="$HOME/Pictures/wallpapers"
      DELAY=300  # 5 minutes

      pgrep -x swww > /dev/null || swww init

      while true; do
        find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) | shuf | while read -r img; do
          swww img "$img" --transition-type fade --transition-duration 2
          sleep "$DELAY"
        done
      done
    '';
  };
}
