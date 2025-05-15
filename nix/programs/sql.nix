# programs/desktop.nix
{pkgs, ...}: {
  # Configure default applications
  environment.systemPackages = with pkgs; [
    mssql
    sqlcmd
    jetbrains.datagrip
  ];
}
