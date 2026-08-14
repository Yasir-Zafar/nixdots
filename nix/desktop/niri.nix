{
  pkgs,
  inputs,
  ...
}: {
  programs.niri = {
    enable = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
  };

  programs.xwayland.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
    config = {
      common = {
        default = ["gnome"];
        # "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
        # "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
        # "org.freedesktop.impl.portal.Screenshot" = ["gnome"];
        # "org.freedesktop.impl.portal.Inhibit" = ["gnome"];
      };
    };
  };

  security = {
    polkit.enable = true;
    pam.services.swaylock = {};
  };

  programs.noctalia = {
    enable = true;

    # Enables NetworkManager, Bluetooth, UPower, and a power profile service.
    recommendedServices.enable = true;
  };

  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    wl-clipboard
    wlr-randr
    cliphist
    grim
    slurp
    swappy
    brightnessctl
    playerctl
    libnotify
    xdg-utils
    jq
    polkit_gnome
    gnome-keyring
    xwayland-satellite
  ];

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = ["graphical-session.target"];
    wants = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
