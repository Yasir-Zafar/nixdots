# Every home module. To turn one off, comment out its line.
{
  imports = [
    ./secrets.nix # sops-nix: secrets/secrets.yaml
    ./dotfiles.nix # nixvim
    #./scripts/default.nix # superseded by nx (pkgs/nx), kept for reference
    ./desktop/default.nix
    ./terminal/default.nix
    ./development/default.nix
    ./applications/default.nix
  ];
}
