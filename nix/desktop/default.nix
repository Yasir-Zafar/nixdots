# Active desktop: niri + sysc-greet (greetd).
# Every greeter has its own set of problems, so the others are kept alongside:
#   default-tuigreet.nix  tuigreet (the previous default)
#   default-ldm.nix       lightdm
#   default-g.nix         gdm
#   default-l.nix         ly
# Swap the `./desktop` import in ../configuration.nix to try another.
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./fonts.nix
    ./media-libs.nix
    ./niri.nix
  ];

  services = {
    accounts-daemon.enable = true;

    sysc-greet = {
      enable = true;
      compositor = "niri";
      # greeter compositor: the same niri the session uses
      niriPackage = config.programs.niri.package;
    };

    gnome = {
      gnome-keyring.enable = true;
      sushi.enable = true;
      at-spi2-core.enable = true;
    };
    gvfs.enable = true;
    flatpak.enable = true;
  };

  # sysc-greet has no declarative config: it reads its saved choices from the
  # greeter's cache. Seed them (gruvbox + ascii rain) on every boot/switch.
  systemd.tmpfiles.rules = [
    "d /var/lib/greeter/.cache 0755 greeter greeter -"
    "d /var/lib/greeter/.cache/sysc-greet 0755 greeter greeter -"
    "f+ /var/lib/greeter/.cache/sysc-greet/preferences 0644 greeter greeter - {\\x22theme\\x22:\\x22Gruvbox\\x22,\\x22background\\x22:\\x22ascii-rain\\x22,\\x22follow_shell\\x22:false}"
  ];

  system.activationScripts.userIcons = ''
    mkdir -p /var/lib/AccountsService/icons
    cp ${./../../assets/profile.jpg} /var/lib/AccountsService/icons/boi
    echo -e "[User]\nIcon=/var/lib/AccountsService/icons/boi\n" > /var/lib/AccountsService/users/boi
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
      gnome-usage
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
