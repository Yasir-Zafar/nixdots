# boi: user-level settings; the modules themselves are in modules/home.
{my, ...}: {
  imports = [
    ../modules/home
  ];

  home = {
    username = my.user;
    homeDirectory = my.home;
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;

  # allowUnfree is set where pkgs is imported (flake.nix); setting nixpkgs.config here
  # as well would make home-manager import nixpkgs a second time
}
