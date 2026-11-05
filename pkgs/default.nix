# Packages that aren't in nixpkgs, added to pkgs as an overlay by both flakes, so modules
# use them as pkgs.<name>. Build one on its own with
#   nix build ~/dots/hm#homeConfigurations.boi.pkgs.<name>
# nx-sh (the bash fallback for nx) is a list of packages, not one, so it isn't in here;
# see modules/home/terminal/nx.nix.
final: _prev: {
  nx = final.callPackage ./nx {};
  way-clicker = final.callPackage ./way-clicker {};
  basecamp-linux = final.callPackage ./basecamp-linux {};
  charge-grinder = final.callPackage ./charge-grinder {};
  omnisearch = final.callPackage ./omnisearch {};
}
