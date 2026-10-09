# Default applications: one place for "what opens what".
# Change an app here and both the env vars and the xdg mime handlers follow.
{lib, ...}: let
  browser = "zen-beta.desktop";
  video = "mpv.desktop";
  image = "org.gnome.Loupe.desktop";
  pdf = "org.gnome.Papers.desktop";
  text = "org.gnome.TextEditor.desktop";
  files = "org.gnome.Nautilus.desktop";
  archive = "org.gnome.FileRoller.desktop";

  assign = app: types: lib.genAttrs types (_: [app]);
in {
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "zen-beta";
    TERMINAL = "ghostty";
    MANPAGER = "nvim +Man!";
  };

  xdg.mimeApps = {
    enable = true;

    defaultApplications = lib.mkMerge [
      (assign browser [
        "text/html"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/about"
        "x-scheme-handler/unknown"
      ])

      (assign video [
        "video/mp4"
        "video/x-matroska"
        "video/webm"
        "audio/mpeg"
        "audio/flac"
      ])

      (assign image [
        "image/jpeg"
        "image/png"
        "image/gif"
      ])

      (assign pdf ["application/pdf"])
      (assign text ["text/plain"])
      (assign files ["inode/directory"])
      (assign archive [
        "application/zip"
        "application/x-tar"
        "application/x-7z-compressed"
        "application/gzip"
      ])
    ];
  };
}
