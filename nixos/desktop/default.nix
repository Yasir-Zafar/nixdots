{ pkgs, ... }:
{
  imports = [
    ./gnome.nix
    ./fonts.nix
  ];
  services = {
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
  
      autologin = {
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
  };

  security = {
    polkit.enable = true;
    pam.services.gdm.enableGnomeKeyring = true;
  };
}
