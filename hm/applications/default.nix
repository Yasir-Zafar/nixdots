{
  imports = [
    ./ghostty.nix
    ./media.nix
    ./utilities.nix
    #./easyeffect.nix
  ];

  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      # Web Browser
      "text/html" = ["firefox.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
      "x-scheme-handler/about" = ["firefox.desktop"];
      "x-scheme-handler/unknown" = ["firefox.desktop"];

      # Video & Audio
      "video/mp4" = ["mpv.desktop"];
      "video/x-matroska" = ["mpv.desktop"];
      "video/webm" = ["mpv.desktop"];
      "audio/mpeg" = ["mpv.desktop"];
      "audio/flac" = ["mpv.desktop"];

      # Images
      "image/jpeg" = ["org.gnome.Loupe.desktop"]; # or "imv.desktop", "feh.desktop"
      "image/png" = ["org.gnome.Loupe.desktop"];
      "image/gif" = ["org.gnome.Loupe.desktop"];

      # Documents / Text
      "application/pdf" = ["org.gnome.Papers.desktop"];
      "text/plain" = ["org.gnome.TextEditor.desktop"];
    };
  };
}
