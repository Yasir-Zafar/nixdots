# hm/development/tools/sql.nix
{pkgs, ...}: {
  # Terminal applications and tools
  home.packages = with pkgs; [
    sqlite
  ];
}
