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
    imv # Simple image viewer for Wayland

    # Screenshot utilities
    grimblast # Screenshots for Hyprland

    # Media utilities
    ffmpeg
    yt-dlp
    obs-studio
  ];
}
