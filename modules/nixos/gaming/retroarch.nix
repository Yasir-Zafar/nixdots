{pkgs, ...}: let
  retroarchWithCores = pkgs.retroarch.withCores (cores:
    with cores; [
      melonds
      mgba
    ]);
in {
  environment.systemPackages = with pkgs; [
    retroarchWithCores
    ryubing
    pcsx2
  ];
}
