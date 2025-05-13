{ pkgs, ... }:

{
  # Basic media packages
  home.packages = with pkgs; [
    # Audio players
    mpv

    # Video players
    vlc

    # Image tools
    gimp
    inkscape
    imv

    # Screenshot utilities
    grimblast

    # Media utilities
    ffmpeg
    yt-dlp
    obs-studio

    # office suite
    libreoffice
  ];
}
