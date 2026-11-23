# boi: user-level settings; the modules themselves are in modules/home.
{my, ...}: {
  imports = [
    ../modules/home
  ];

  home = {
    username = my.user;
    homeDirectory = my.home;
    stateVersion = "25.05";
    # modules keep their files under ~/.config where they can
    preferXdgDirectories = true;
  };

  # XDG_* vars, so config.xdg.* can be used for paths
  xdg.enable = true;

  # nix profile under ~/.local/state/nix (pairs with nixos/nix.nix)
  nix.assumeXdg = true;

  programs.home-manager.enable = true;

  # allowUnfree lives in flake.nix; setting it here imports nixpkgs twice
}
