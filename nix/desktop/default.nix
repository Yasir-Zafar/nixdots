{pkgs, ...}: {
  imports = [
    ./fonts.nix
    ./niri.nix
  ];
  services = {
    accounts-daemon.enable = true;

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions /run/current-system/sw/share/wayland-sessions --cmd niri-session";
          user = "greeter";
        };
      };
    };

    gnome = {
      gnome-keyring.enable = true;
      sushi.enable = true;
      at-spi2-core.enable = true;
    };
    gvfs.enable = true;
    flatpak.enable = true;
  };

  system.activationScripts.userIcons = ''
    mkdir -p /var/lib/AccountsService/icons
    cp ${./../../assets/profile.jpg} /var/lib/AccountsService/icons/boi
    echo -e "[User]\nIcon=/var/lib/AccountsService/icons/boi\n" > /var/lib/AccountsService/users/boi
  '';

  environment = {
    pathsToLink = ["share/thumbnailers" "share/wayland-sessions"];
    systemPackages = with pkgs; [
      tuigreet

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

      cage
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
