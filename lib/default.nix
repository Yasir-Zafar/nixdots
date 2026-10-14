# Values both flakes share, imported by nix/flake.nix and hm/flake.nix and passed to
# every module as `my`. Change the user, host or an address here, not in the modules.
{
  user = "boi";
  fullName = "Yasir Zafar";
  home = "/home/boi";
  host = "mntbnd";

  git = {
    name = "Yasir-Zafar";
    email = "yasirzafar365@gmail.com";
  };

  # Proton address: mail (thunderbird via the bridge) and npm init
  mail = "mntbnd720@proton.me";

  # repo assets. Use `my.assets + "/file"` so only that file is copied to the store,
  # not the whole folder with the icon theme.
  assets = ../assets;
}
