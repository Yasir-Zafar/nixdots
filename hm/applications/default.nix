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
      "text/html" = ["zen-beta.desktop"];
      "x-scheme-handler/http" = ["zen-beta.desktop"];
      "x-scheme-handler/https" = ["zen-beta.desktop"];
      "x-scheme-handler/about" = ["zen-beta.desktop"];
      "x-scheme-handler/unknown" = ["zen-beta.desktop"];

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
