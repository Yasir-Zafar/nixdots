# hm/development/tools/sql.nix
{
  config,
  pkgs,
  ...
}: {
  # Terminal applications and tools
  home.packages = with pkgs; [
    sqlite
  ];
}
