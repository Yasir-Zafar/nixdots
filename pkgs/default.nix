# my packages, an overlay in both flakes (pkgs.<name>). Build one:
#   nix build ~/dots/hm#homeConfigurations.boi.pkgs.<name>
# nx-sh is a list, not one package: see modules/home/terminal/nx.nix
final: _prev: {
  nx = final.callPackage ./nx {};
  way-clicker = final.callPackage ./way-clicker {};
  basecamp-linux = final.callPackage ./basecamp-linux {};
  charge-grinder = final.callPackage ./charge-grinder {};
  omnisearch = final.callPackage ./omnisearch {};
  claude-desktop = final.callPackage ./claude-desktop {};
}
