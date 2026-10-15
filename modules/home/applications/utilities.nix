# files, thumbnails, monitoring, system helpers
{pkgs, ...}: {
  home.packages = with pkgs; [
    nautilus
    loupe
    ffmpegthumbnailer
    gnome-epub-thumbnailer

    mission-center
    warehouse # flatpak manager
    powertop

    newsflash
    # gdm-settings # only useful with the gdm greeter (modules/nixos/desktop/greeters/gdm.nix)
    impression
    theclicker
    (pkgs.gearlever.override {dwarfs = null;}) # only works if the package supports it
  ];

  # age out thumbnails nobody looked at in 30 days (systemd-tmpfiles-clean, daily)
  systemd.user.tmpfiles.rules = [
    "e %h/.cache/thumbnails - - - 30d"
  ];

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "gruvbox_material_dark"; # btop's own theme, not stylix
      theme_background = true;
      truecolor = true;
      rounded_corners = true;
      update_ms = 2000;
    };
  };
}
