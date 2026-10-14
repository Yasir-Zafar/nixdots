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

  # repo assets. Use `my.assets + "/file"` so only that file is copied to the store,
  # not the whole folder with the icon theme.
  assets = ../assets;
}
