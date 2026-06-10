{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./fonts.nix
    ./niri.nix
  ];

  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "matrix"; # none | doom | matrix | colorcycle
      clock = "%H:%M  %a %d %b";
      vi_mode = false;
      asterisk = "*";
    };
  };

  services = {
    gnome = {
      gnome-keyring.enable = true;
      sushi.enable = true;
      at-spi2-core.enable = true;
    };

    gvfs.enable = true;
  };

  services.flatpak.enable = true;

  environment = {
    pathsToLink = ["share/thumbnailers"];

    systemPackages = with pkgs; [
      gnome-calendar
      gnome-calculator
      gnome-usage
      gnome-disk-utility
      file-roller
      gnome-autoar

      sassc
      gtk-engine-murrine
      gnome-themes-extra

      libheif
      libheif.out

      inputs.zen-browser.packages."${stdenv.hostPlatform.system}".default
    ];
  };

  environment.etc."xdg/user-dirs.defaults".text = ''
    DESKTOP=
    DOWNLOAD=Downloads
    TEMPLATES=
    PUBLICSHARE=
    DOCUMENTS=Documents
    MUSIC=Music
    PICTURES=Pictures
    VIDEOS=Videos
  '';
}
