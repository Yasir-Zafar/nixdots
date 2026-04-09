{pkgs, ...}: {
  home.packages = with pkgs; [
    noctal
  ];
}
