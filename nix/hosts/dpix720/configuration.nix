  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.flatpak.enable = true; 

  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;

  services.power-profiles-daemon.enable = true;
  programs.hyprland.enable = true;

