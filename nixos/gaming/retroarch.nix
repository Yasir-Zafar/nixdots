{pkgs, ...}: let
  retroarchWithCores = pkgs.retroarch.withCores (cores:
    with cores; [
      melonds
      citra
      mgba
    ]);
in {
  # Gaming applications and utilities
  environment.systemPackages = with pkgs; [
    retroarchWithCores
  ];
}
