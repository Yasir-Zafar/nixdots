{
  pkgs,
  inputs,
  ...
}: {
  users.users.boi.packages = with pkgs; [
    inputs.zen-browser.packages."${stdenv.hostPlatform.system}".default
    wineWow64Packages.stable
    git
    vim
  ];
}
