{

  home.file = {

    ".config/lf/lfrc".source = lf/lfrc;

    ".config/mpd/mpd.conf".source = mpd/mpd.conf;

    ".config/nvim/init.lua".source = nvim/init.lua;
    ".config/nvim/lazy-lock.json".source = nvim/lazy-lock.json;
    ".config/nvim/lua" = {

      source = nvim/lua;
      recursive = true;

    };

    ".config/qutebrowser/config.py".source = qutebrowser/config.py;

    ".emacs.d/config.org".source = emacs/config.org;

    ".config/waybar/style.css".source = waybar/style.css;
    ".config/waybar/config".source = waybar/config;

    ".config/wofi/style.css".source = wofi/style.css;

    ".config/hypr/hyprland.conf".source = hypr/hyprland.conf;

    ".config/ncmpcpp/notify_mpd.sh".source = ncmpcpp/notify_mpd.sh;

  };

}
