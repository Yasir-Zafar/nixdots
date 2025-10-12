# nixos/desktop/default.nix
{pkgs, ...}: {
  imports = [
    ./gnome.nix
    ./fonts.nix
  ];
  services = {
    # Enable display manager
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };

      autoLogin = {
        enable = true;
        user = "boi";
      };
    };
  };

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
  };

  security = {
    polkit.enable = true;
    pam.services.gdm.enableGnomeKeyring = true;
  };

  services.flatpak.enable = true;
}
