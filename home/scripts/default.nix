{
  home.file.".local/bin/wallpaper-rotator.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      WALLPAPER_DIR="$HOME/Pictures/Wallpapers/100.jpg"

      pgrep -x swww > /dev/null || swww-daemon
      swww img "$img"
      done
    '';
  };
}
