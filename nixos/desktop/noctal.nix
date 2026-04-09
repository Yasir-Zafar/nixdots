{pkgs, ...}: {
  # install noctal
  home.packages = with pkgs; [
    noctal
  ];
}
