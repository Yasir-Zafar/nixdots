# hm/development/default.nix
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./editors
    ./languages
    ./tools
    ./shell
  ];
}
