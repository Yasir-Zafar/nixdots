# files, thumbnails, monitoring, system helpers
{pkgs, ...}: {
  home.packages = with pkgs; [
    nautilus
    loupe
    ffmpegthumbnailer
    gnome-epub-thumbnailer

    mission-center
    powertop

    gnome-feeds
    gdm-settings
    impression
    theclicker
    (pkgs.gearlever.override {dwarfs = null;}) # only works if the package supports it
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
