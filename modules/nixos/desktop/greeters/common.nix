# Shared by every greeter variant: desktop services, the avatar, gnome utility apps
# and the xdg user dirs. The greeter files next to this one only hold what is
# specific to that greeter.
{
  pkgs,
  my,
  ...
}: {
  services = {
    accounts-daemon.enable = true;

    gnome = {
      gnome-keyring.enable = true;
      sushi.enable = true;
      at-spi2-core.enable = true;
    };
    gvfs.enable = true;
    flatpak.enable = true;
  };

  # avatar for greeters that read AccountsService (sysc-greet, lightdm, gdm)
  system.activationScripts.userIcons = ''
    mkdir -p /var/lib/AccountsService/icons
    cp ${my.assets + "/profile.jpg"} /var/lib/AccountsService/icons/${my.user}
    echo -e "[User]\nIcon=/var/lib/AccountsService/icons/${my.user}\n" > /var/lib/AccountsService/users/${my.user}
  '';

  # "Open in terminal" in nautilus; the bare package alone doesn't register the extension
  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "ghostty";
  };

  environment = {
    pathsToLink = ["share/thumbnailers" "share/wayland-sessions"];
    systemPackages = with pkgs; [
      gnome-calendar
      gnome-calculator
      # gnome-usage # mission-center (home: applications/utilities.nix) covers it
      gnome-disk-utility
      file-roller
      gnome-autoar
      sassc
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
