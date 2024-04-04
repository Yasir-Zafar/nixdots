{
  home.file = {
    ".config/mpd/mpd.conf".source = mpd/mpd.conf;

    # ".config/nvim" = {

    #  source = ./nvim;
    #  recursive = true;

    # };

    ".config/waybar/style.css".source = waybar/style.css;
    ".config/waybar/config".source = waybar/config;

    ".config/wofi/style.css".source = wofi/style.css;

    ".config/hypr/hyprland.conf".source = hypr/hyprland.conf;

    ".config/swayidle/config".source = idle/config;
  };
}
