{pkgs, ...}: let
  retroarchWithCores = pkgs.retroarch.withCores (cores:
    with cores; [
      melonds
      mgba
    ]);
in {
  # Gaming applications and utilities
  environment.systemPackages = with pkgs; [
    retroarchWithCores
  ];
}
