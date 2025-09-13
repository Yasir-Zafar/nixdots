# hm/development/languages/default.nix
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./java.nix
    ./javascript.nix
    ./python.nix
  ];
}
