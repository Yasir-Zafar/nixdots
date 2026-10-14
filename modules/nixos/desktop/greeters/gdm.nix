# GDM (gnome's display manager), without the gnome desktop (that is ../gnome.nix)
{pkgs, ...}: {
  services.displayManager.gdm.enable = true;

  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gnome];

  security.pam.services.gdm.enableGnomeKeyring = true;

  # gtk-engine-murrine (gtk2 theme engine) used to be installed here; nixpkgs removed it with gtk2
}
