# hm/development/editors/default.nix
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./neovim.nix
    ./jetbrains.nix
  ];
}
