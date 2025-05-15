# programs/desktop.nix
{
  pkgs,
  inputs,
  ...
}: {
  # Configure default applications
  environment.systemPackages = with pkgs; [
    inputs.nix-software-center.packages.${system}.nix-software-center
    # Media players
    mpv

    # File managers
    nautilus
    lf

    # Utilities
    xdg-utils
    file-roller

    # flatpak
    pavucontrol
    mission-center
    gnome-usage
    gnome-disk-utility
    showtime
    papers
    amberol
    gearlever
    boxes
    nicotine-plus
    parabolic
    cartridges
    foliate
    gnome-solanum
    gnome-podcasts
    gnome-mahjongg

    # emulators
    melonDS
    dolphin-emu
    azahar
  ];

  # Programs with special configuration
  programs = {
    # Steam
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    # Dconf for GTK applications
    dconf.enable = true;

    # Kdeconnect
    kdeconnect.enable = true;

    # GnuPG
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  # Enable flatpak
  services.flatpak.enable = true;

  # Configure MIME types
  xdg.mime = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.pwmt.zathura.desktop";
      "image/jpeg" = "imv.desktop";
      "image/jpg" = "imv.desktop";
      "image/png" = "imv.desktop";
      "image/gif" = "imv.desktop";
      "video/mp4" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      "inode/directory" = "pcmanfm.desktop";
      "text/plain" = "org.gnome.gedit.desktop";
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };
}
