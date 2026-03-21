{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    statix
    deadnix
    alejandra
  ];
}
