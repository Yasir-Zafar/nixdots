{pkgs, ...}: {
  programs = {
    niri.enable = true;
    xwayland.enable = true;

    noctalia = {
      enable = true;

      # Enables NetworkManager, Bluetooth, UPower, and a power profile service.
      recommendedServices.enable = true;
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    # MOZ_ENABLE_WAYLAND and CLUTTER_BACKEND dropped: firefox/zen default to wayland, clutter is gone
    QT_QPA_PLATFORM = "wayland;xcb";
    # x11 fallback: old/bundled SDL2 games without wayland support fail with plain "wayland"
    SDL_VIDEODRIVER = "wayland,x11";
  };

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

  environment.systemPackages = with pkgs; [
    # noctalia itself: installed by the home-manager module (hm/desktop/noctalia.nix)
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
    xwayland-satellite
    libdisplay-info
  ];

  # niri-flake ships its own polkit agent (kde); ours below already registers first,
  # so the second one fails on every login ("an authentication agent already exists")
  systemd.user.services.niri-flake-polkit.enable = false;

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
