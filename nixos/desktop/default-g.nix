{pkgs, ...}: {
  imports = [
    ./gnome.nix
    ./fonts.nix
    ./niri.nix
  ];

  services.displayManager = {
    gdm = {
      enable = true;
      wayland = true;
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
    ];
  };

  security = {
    polkit.enable = true;
    pam.services.gdm.enableGnomeKeyring = true;
  };

  services.flatpak.enable = true;
}
