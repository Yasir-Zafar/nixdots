# theme (gruvbox kvantum + qtct) comes from stylix, see stylix.nix
{pkgs, ...}: {
  qt.enable = true;

  home.sessionVariables = {
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  };

  home.packages = with pkgs; [
    qt6Packages.qt6ct
  ];
}
