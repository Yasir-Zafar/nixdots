# Default applications: one place for "what opens what".
# Change an app here and both the env vars and the xdg mime handlers follow.
{lib, ...}: let
  browser = "zen-beta.desktop";
  # first one is the default, mpv is the fallback ("open with" lists it next)
  video = ["org.gnome.Showtime.desktop" "mpv.desktop"];
  audio = ["io.bassi.Amberol.desktop" "mpv.desktop"];
  image = "org.gnome.Loupe.desktop";
  pdf = "org.gnome.Papers.desktop";
  text = "org.gnome.TextEditor.desktop";
  markdown = "org.gnome.gitlab.somas.Apostrophe.desktop";
  files = "org.gnome.Nautilus.desktop";
  archive = "org.gnome.FileRoller.desktop";
  mail = "thunderbird.desktop";
  windows = "wine.desktop"; # from the system wine (nixos/users/packages.nix)

  assign = app: types: lib.genAttrs types (_: lib.toList app);
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
        "video/quicktime"
        "video/x-msvideo"
        "video/mpeg"
        "video/ogg"
        "video/x-flv"
        "video/3gpp"
        "video/x-ms-wmv"
        "video/mp2t"
        "video/x-ogm+ogg"
      ])

      (assign audio [
        "audio/mpeg"
        "audio/flac"
        "audio/ogg"
        "audio/opus"
        "audio/x-wav"
        "audio/mp4"
        "audio/x-flac"
        "audio/wav"
        "audio/x-m4a"
        "audio/aac"
        "audio/x-vorbis+ogg"
        "audio/webm"
        "audio/x-matroska"
      ])

      (assign image [
        "image/jpeg"
        "image/png"
        "image/gif"
        "image/webp"
        "image/avif"
        "image/svg+xml"
        "image/heif"
        "image/heic"
        "image/bmp"
        "image/tiff"
        "image/jxl"
        "image/x-icon"
        "image/vnd.microsoft.icon"
        "image/x-portable-pixmap"
      ])

      (assign pdf ["application/pdf"])
      (assign text [
        "text/plain"
        "application/json"
        "application/xml"
        "application/toml"
        "application/x-yaml"
        "application/x-shellscript"
        "text/x-python"
        "text/x-python3"
        "text/x-csrc"
        "text/x-chdr"
        "text/x-c++src"
        "text/rust"
        "text/x-java"
        "text/x-rst"
        "text/x-log"
        "text/x-nix"
        "text/x-lua"
        "text/javascript"
        "text/css"
        "application/sql"
        "text/x-makefile"
      ])
      (assign markdown ["text/markdown"])
      (assign mail ["x-scheme-handler/mailto"])
      (assign files ["inode/directory"])
      (assign archive [
        "application/zip"
        "application/x-tar"
        "application/x-7z-compressed"
        "application/gzip"
        "application/x-xz"
        "application/x-bzip2"
        "application/zstd"
        "application/vnd.rar"
        "application/x-rar"
        "application/x-compressed-tar"
        "application/x-xz-compressed-tar"
        "application/x-bzip2-compressed-tar"
        "application/x-zstd-compressed-tar"
      ])
      # .exe is detected as the first type; the rest are what wine.desktop lists
      (assign windows [
        "application/vnd.microsoft.portable-executable"
        "application/x-msdownload"
        "application/x-ms-dos-executable"
        "application/x-msi"
        "application/x-ms-shortcut"
        "application/x-bat"
      ])
    ];
  };
}
