# hm/development/editors/default.nix
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./jetbrains.nix
  ];
}
