# hm/development/editors/default.nix
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./jetbrains.nix
    ./cursor.nix
    ./vscode.nix
  ];
}
