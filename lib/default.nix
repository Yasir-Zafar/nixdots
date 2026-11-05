# Values both flakes share, imported by nix/flake.nix and hm/flake.nix and passed to
# every module as `my`. Change the user, host or an address here, not in the modules.
{
  user = "boi";
  fullName = "Yasir Zafar";
  home = "/home/boi";
  host = "mntbnd";

  # e-mail addresses are not here: they're in secrets/secrets.yaml (sops), so the
  # public repo doesn't carry them
  git.name = "Yasir-Zafar";

  # gruvbox dark medium, for configs that take raw hex (niri, bspwm/polybar/rofi/dunst)
  colors = {
    bg = "#282828";
    bg1 = "#3c3836";
    bg2 = "#504945";
    fg = "#ebdbb2";
    gray = "#928374";
    red = "#fb4934";
    yellow = "#fabd2f";
    orange = "#fe8019";
  };

  # repo assets. Use `my.assets + "/file"` so only that file is copied to the store,
  # not the whole folder with the icon theme.
  assets = ../assets;
}
