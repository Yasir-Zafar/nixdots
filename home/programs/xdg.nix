{ config, pkgs, ...}:

{

  xdg = {
    
    userDirs = {

      enable = true;
      documents = "${config.home.homeDirectory}/Data/Documents";
      download  = "${config.home.homeDirectory}/Data/Downloads";
      music     = "${config.home.homeDirectory}/Data/Music";
      pictures  = "${config.home.homeDirectory}/Data/Pictures";
      videos    = "${config.home.homeDirectory}/Data/Videos";
      templates = "";
      desktop   = "";

    };

    mimeApps = {

      enable = true;
      defaultApplications = {

        "image" = [ "imv.desktop" ];
        "audio" = [ "mpv.desktop" ];
        "video" = [ "mpv.desktop" ];
        "application/pdf" = [ "emacs.desktop" ];
        "text/plain" = "emacs.desktop";
        "application/vnd.oasis.opendocument.text" = "libreoffice-writer.desktop";
        "application/vnd.oasis.opendocument.spreadsheet" = "libreoffice-calc.desktop";
        "application/vnd.oasis.opendocument.presentation" = "libreoffice-impress.desktop";
        
        # Web browser
        "text/html" = "firefox.desktop";

        # Video files
        "video/mp4" = "mpv.desktop";
        "video/x-matroska" = "mpv.desktop";

        # Audio files
        "audio/mpeg" = "mpv.desktop";
        "audio/ogg" = "mpv.desktop";

        # Archive files
        "application/zip" = "org.gnome.nautilus.desktop";

      };

    };

  };

}
