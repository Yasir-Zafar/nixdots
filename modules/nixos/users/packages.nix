{
  pkgs,
  inputs,
  my,
  ...
}: {
  users.users.${my.user}.packages = with pkgs; [
    inputs.zen-browser.packages."${stdenv.hostPlatform.system}".default
    wineWow64Packages.stable
    git
    vim
  ];
}
