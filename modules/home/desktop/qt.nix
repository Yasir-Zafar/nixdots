# Qt apps follow the GTK theme (set with nwg-look) through Qt's own GTK3 platform
# theme: GTK fonts, icons, dialogs and colours. There is no `style`: the gtk2 style
# (qt6gtk2) was removed from nixpkgs with gtk2, and kvantum/adwaita would override GTK.
{
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  home.sessionVariables = {
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  };
}
