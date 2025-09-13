{pkgs, ...}: {
  imports = [
    ./steam.nix
    ./performance.nix
  ];

  environment.systemPackages = with pkgs; [
    gamemode
    mangohud

    bottles
  ];
}
