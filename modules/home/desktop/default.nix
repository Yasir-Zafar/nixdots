{pkgs, ...}: {
  imports = [
    #./gnome-settings.nix
    ./stylix.nix
    ./gtk.nix
    ./qt.nix
    ./mango.nix # default session
    ./niri-config.nix
    ./bspwm.nix
    ./noctalia.nix
    ./font-trial.nix
  ];

  # hide polkit-gnome's xdg autostart copy: the user service already runs it
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
