{pkgs, ...}: {
  home.packages = with pkgs; [
    showtime
    pear-desktop
    obs-studio
    kooha

    gimp
    krita
    pinta

    amberol
    gnome-podcasts

    papers
    libreoffice
    obsidian
    foliate
    gnome-notes

    vesktop
    thunderbird
    nicotine-plus
    zoom-us

    ffmpeg
    yt-dlp
    parabolic
    fragments
    aria2

    gnome-epub-thumbnailer
  ];

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
