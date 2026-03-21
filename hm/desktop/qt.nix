{pkgs, ...}: {
  qt = {
    enable = true;
    platformTheme.name = "gtk";

    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  home.sessionVariables = {
    QT_STYLE_OVERRIDE = "adwaita-dark";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  };

  home.packages = with pkgs; [
    qt6Packages.qt6ct
    libsForQt5.qtstyleplugins
  ];
}
