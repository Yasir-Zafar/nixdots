# hm/applications/media.nix
{
  config,
  pkgs,
  ...
}: {
  # Media applications
  home.packages = with pkgs; [
    # Video players
    vlc
    mpv
    celluloid

    # Image viewers/editors
    eog # GNOME image viewer
    gimp
    imagemagick

    # Audio
    audacity
    pavucontrol # PulseAudio/PipeWire volume control

    # Media tools
    ffmpeg
    yt-dlp # YouTube downloader

    # Document viewers
    papers # PDF viewer
    libreoffice

    # Streaming
    obs-studio

    # Music
    spotify
    amberol
    # rhythmbox  # GNOME music player alternative
  ];

  # MPV configuration
  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto-safe";
      vo = "gpu";
      profile = "gpu-hq";
      scale = "ewa_lanczossharp";
      cscale = "ewa_lanczossharp";
      video-sync = "display-resample";
      interpolation = true;
      tscale = "oversample";
    };
  };
}
