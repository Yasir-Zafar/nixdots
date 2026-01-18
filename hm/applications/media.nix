# hm/applications/media.nix
{pkgs, ...}: {
  # Media applications
  home.packages = with pkgs; [
    # Video players
    showtime
    pear-desktop

    # Image viewers/editors
    gimp
    krita

    # Audio
    pavucontrol # PulseAudio/PipeWire volume control

    # Document viewers
    papers
    libreoffice
    obsidian

    # Streaming
    obs-studio
    kooha

    # Communication
    vesktop
    thunderbird
    nicotine-plus
    vesktop
    zoom-us

    # Music
    amberol
    gnome-podcasts

    # Reading & Learning
    foliate

    # Media utilities
    ffmpeg
    yt-dlp
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
