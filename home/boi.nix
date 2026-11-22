# boi: user-level settings; the modules themselves are in modules/home.
{my, ...}: {
  imports = [
    ../modules/home
  ];

  home = {
    username = my.user;
    homeDirectory = my.home;
    stateVersion = "25.05";
    # modules that can keep their files under ~/.config etc. instead of ~ do so
    # (gtk2's .gtkrc-2.0, lazygit, atuin here)
    preferXdgDirectories = true;
  };

  # XDG_CONFIG_HOME/DATA/STATE/CACHE set to the usual ~/.config, ~/.local/share,
  # ~/.local/state, ~/.cache, so config.xdg.* can be used for paths
  xdg.enable = true;

  # nix profile and channels under ~/.local/state/nix instead of ~/.nix-profile and
  # ~/.nix-defexpr; pairs with use-xdg-base-directories in nixos/nix.nix
  nix.assumeXdg = true;

  programs.home-manager.enable = true;

  # allowUnfree is set where pkgs is imported (flake.nix); setting nixpkgs.config here
  # as well would make home-manager import nixpkgs a second time
}
