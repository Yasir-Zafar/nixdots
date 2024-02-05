{

  environment.systemPackages = with pkgs;
  [
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
  ];
  nixpkgs.config.qt5 = {
    enable = true;
    platformTheme = "qt5ct"; 
  };

}
