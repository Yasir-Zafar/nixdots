# hm/development/shell/default.nix
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./bash.nix
    ./aliases.nix
    ./environment.nix
  ];
}
