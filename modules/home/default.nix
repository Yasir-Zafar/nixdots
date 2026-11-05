# Every home module. To turn one off, comment out its line.
{
  imports = [
    ./secrets.nix # sops-nix: secrets/secrets.yaml
    #./xdg.nix # old user-dirs / mime setup, kept for reference
    #./scripts/default.nix # superseded by nx (pkgs/nx-sh), kept for reference
    ./desktop/default.nix
    ./terminal/default.nix
    ./development/default.nix
    ./applications/default.nix
  ];
}
