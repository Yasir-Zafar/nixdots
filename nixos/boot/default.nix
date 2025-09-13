# nixos/boot/default.nix
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./systemd-boot.nix
  ];
}
