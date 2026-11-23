# values both flakes share, passed to every module as `my`
{
  user = "boi";
  fullName = "Yasir Zafar";
  home = "/home/boi";
  host = "mntbnd";

  # e-mail addresses: secrets/secrets.yaml (sops)
  git.name = "Yasir-Zafar";

  # gruvbox dark medium, for configs that take raw hex (niri, bspwm/polybar/rofi/dunst)
  colors = {
    bg = "#282828";
    bg1 = "#3c3836";
    bg2 = "#504945";
    bg3 = "#665c54";
    fg = "#ebdbb2";
    gray = "#928374";
    red = "#fb4934";
    yellow = "#fabd2f";
    orange = "#fe8019";
    blue = "#83a598";
  };

  # use `my.assets + "/file"` so only that file goes to the store
  assets = ../assets;
}
