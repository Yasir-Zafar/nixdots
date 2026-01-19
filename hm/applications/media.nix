# ============================================================================
# Media Applications Configuration
# Location: hm/applications/media.nix
# ============================================================================
{pkgs, ...}: {
  # ==========================================================================
  # MEDIA PACKAGES
  # ==========================================================================
  home.packages = with pkgs; [
    # ------------------------------------------------------------------------
    # Video Players & Editors
    # ------------------------------------------------------------------------
    showtime # Modern video player
    pear-desktop # Video player alternative
    obs-studio # Streaming and recording
    kooha # Screen recorder

    # ------------------------------------------------------------------------
    # Image Viewers & Editors
    # ------------------------------------------------------------------------
    gimp # Advanced image editor
    krita # Digital painting and illustration
    pinta # Simple image editor (Paint.NET alternative)

    # ------------------------------------------------------------------------
    # Audio Tools
    # ------------------------------------------------------------------------
    pavucontrol # PulseAudio/PipeWire volume control
    amberol # Music player
    gnome-podcasts # Podcast player

    # ------------------------------------------------------------------------
    # Document Viewers & Productivity
    # ------------------------------------------------------------------------
    papers # Document viewer (PDF, ePub, etc.)
    libreoffice # Office suite
    obsidian # Note-taking and knowledge management
    foliate # E-book reader
    gnome-notes # Simple note-taking

    # ------------------------------------------------------------------------
    # Communication
    # ------------------------------------------------------------------------
    vesktop # Discord client with Vencord
    thunderbird # Email client
    nicotine-plus # Soulseek P2P file sharing
    zoom-us # Video conferencing

    # ------------------------------------------------------------------------
    # Media Utilities
    # ------------------------------------------------------------------------
    ffmpeg # Video/audio processing
    yt-dlp # YouTube and media downloader
    parabolic # GUI for yt-dlp
    gnome-decoder # QR code scanner
    fragments # BitTorrent client
    aria2 # Download manager

    # ------------------------------------------------------------------------
    # Media Format Support
    # ------------------------------------------------------------------------
    gnome-epub-thumbnailer # ePub thumbnails in file manager
  ];

  # ==========================================================================
  # MPV CONFIGURATION
  # ==========================================================================
  # MPV is configured separately with optimized settings
  programs.mpv = {
    enable = true;

    config = {
      # Hardware acceleration
      hwdec = "auto-safe"; # Safe hardware decoding
      vo = "gpu"; # GPU video output

      # Video quality
      profile = "gpu-hq"; # High-quality GPU profile
      scale = "ewa_lanczossharp"; # High-quality upscaling
      cscale = "ewa_lanczossharp"; # High-quality chroma upscaling

      # Smooth playback
      video-sync = "display-resample"; # Sync to display refresh rate
      interpolation = true; # Enable motion interpolation
      tscale = "oversample"; # Temporal interpolation method
    };
  };
}
