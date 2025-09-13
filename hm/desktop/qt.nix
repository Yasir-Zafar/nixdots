# hm/desktop/qt.nix
{
  config,
  pkgs,
  ...
}: {
  # QT configuration
  qt = {
    enable = true;
    platformTheme = "gtk";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  # QT environment variables
  home.sessionVariables = {
    QT_STYLE_OVERRIDE = "adwaita-dark";
  };
}
