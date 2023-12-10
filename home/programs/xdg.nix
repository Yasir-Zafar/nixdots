{ config, pkgs, ...}:

let
  myEmacsDesktopFile = pkgs.writeText "emacs.desktop" ''
    [Desktop Entry]
    Name=Emacs
    Exec=emacs %U
    Type=Application
    NoDisplay=true
    Categories=Development;TextEditor;
    MimeType=text/plain;
  '';

  myMimeAppsList = pkgs.writeText "mimeapps.list" ''
    [Default Applications]
    text/plain=emacs.desktop
    application/vnd.oasis.opendocument.text=libreoffice-writer.desktop
    application/vnd.oasis.opendocument.spreadsheet=libreoffice-calc.desktop
    application/vnd.oasis.opendocument.presentation=libreoffice-impress.desktop
  '';
in
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
        "text/plain" = "emacs.desktop";
        "application/vnd.oasis.opendocument.text" = "libreoffice-writer.desktop";
        "application/vnd.oasis.opendocument.spreadsheet" = "libreoffice-calc.desktop";
        "application/vnd.oasis.opendocument.presentation" = "libreoffice-impress.desktop";

      };

    };

  };

}
