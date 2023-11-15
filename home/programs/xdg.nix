{ config, ...}:
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
        "application/pdf" = [ "org.gnome.Evince.desktop" ];

      };

    };

  };

}
