{pkgs, ...}: {
  imports = [
    #./gnome-settings.nix
    ./stylix.nix
    ./gtk.nix
    ./qt.nix
    ./niri-config.nix
    ./sway.nix
    ./noctalia.nix
  ];

  # polkit-gnome runs as a systemd user service (modules/nixos/desktop/niri.nix); its xdg
  # autostart copy only failed at every login with "an authentication agent already
  # exists". A user entry with Hidden=true switches that copy off.
  xdg.configFile."autostart/polkit-gnome-authentication-agent-1.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=PolicyKit Authentication Agent
    Hidden=true
  '';

  home.packages = with pkgs; [
    bibata-cursors
  ];
}
