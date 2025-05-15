# programs/default.nix
{
  imports = [
    ./gaming
    ./hyprland.nix
    ./shells.nix
    ./desktop.nix
    ./sql.nix
  ];
}
