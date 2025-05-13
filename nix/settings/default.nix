# settings/default.nix
{
  imports = [
    ./locale.nix
    ./nix.nix
    ./security.nix
    ./fonts.nix
  ];
}
