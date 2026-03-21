{pkgs, ...}: {
  home.packages = with pkgs; [
    jetbrains.pycharm
    jetbrains.webstorm
    jetbrains.clion
    jetbrains.datagrip
  ];
}
