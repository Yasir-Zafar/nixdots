# hm/applications/default.nix
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./media.nix
    ./utilities.nix
    ./ghostty.nix
    # ./easyeffect.nix
  ];
}
