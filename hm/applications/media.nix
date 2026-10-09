{pkgs, ...}: {
  home.packages = with pkgs; [
    showtime
    pear-desktop
    amberol
    gnome-podcasts
    ffmpeg

    obs-studio
    # kooha

    # gimp
    # krita
    pinta
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
