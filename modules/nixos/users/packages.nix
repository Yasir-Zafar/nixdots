{
  pkgs,
  my,
  ...
}: {
  users.users.${my.user}.packages = with pkgs; [
    # zen: now installed and configured by home-manager (modules/home/applications/zen.nix)
    # inputs.zen-browser.packages."${stdenv.hostPlatform.system}".default
    wineWow64Packages.stable
    git
    vim
  ];
}
