# home/settings/xdg.nix
{
  # XDG Base Directory specification
  xdg = {
    enable = true;

    # MIME type associations
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];
        "image/png" = [ "imv.desktop" ];
        "image/jpeg" = [ "imv.desktop" ];
        "image/gif" = [ "imv.desktop" ];
        "text/html" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/about" = [ "firefox.desktop" ];
        "x-scheme-handler/unknown" = [ "firefox.desktop" ];
        "x-scheme-handler/discord" = [ "discord.desktop" ];
        "x-scheme-handler/magnet" = [ "transmission-gtk.desktop" ];
        "x-scheme-handler/mailto" = [ "thunderbird.desktop" ];
        "audio/mpeg" = [ "mpv.desktop" ];
        "audio/wav" = [ "mpv.desktop" ];
        "video/mp4" = [ "mpv.desktop" ];
        "video/webm" = [ "mpv.desktop" ];
        "video/x-matroska" = [ "mpv.desktop" ];
        "inode/directory" = [ "nautilus.desktop" ];
        "text/plain" = [ "nvim.desktop" ];
      };
    };

    configFile = {
      # Add custom XDG config files here
    };

    userDirs = {
      enable = true;
      createDirectories = true;
      documents = "$HOME/Documents";
      download = "$HOME/Downloads";
      music = "$HOME/Music";
      pictures = "$HOME/Pictures";
      videos = "$HOME/Videos";
      extraConfig = {
        XDG_PROJECTS_DIR = "$HOME/Projects";
        XDG_GAMES_DIR = "$HOME/Games";
      };
    };
  };
}
