# hm/development/tools/default.nix
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./git.nix
    ./terminal.nix
    ./version-control.nix
    ./sql.nix
  ];
}
