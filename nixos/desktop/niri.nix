{
  pkgs,
  inputs,
  ...
}: {
  # niri is a scrollable-tiling Wayland compositor
  # programs.niri at the system level installs the binary and sets up
  # the session entry so greetd/display managers can see it
  programs.niri = {
    enable = true;
    # package = pkgs.niri; # override if you want a different variant
  };

  # Wayland session vars needed by many apps
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # hint Electron/Chromium apps to use Wayland
    MOZ_ENABLE_WAYLAND = "1"; # Firefox
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
  };

  # XWayland for apps that still need X11
  programs.xwayland.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
    config = {
      niri = {
        default = ["gtk"];
        "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
        "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
        "org.freedesktop.impl.portal.Screenshot" = ["gnome"];
        "org.freedesktop.impl.portal.Inhibit" = ["gnome"];
      };
    };
  };

  security = {
    polkit.enable = true;
    pam.services.swaylock = {};
  };

  # common packages useful with any Wayland compositor
  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    wl-clipboard # wl-copy / wl-paste
    wlr-randr # xrandr equivalent for wlroots
    cliphist # clipboard history daemon
    grim # screenshot
    slurp # region selector (used with grim)
    swappy # screenshot annotation
    brightnessctl # backlight control
    playerctl # MPRIS media control
    libnotify # notify-send
    xdg-utils # xdg-open etc.
    jq
    polkit_gnome # polkit auth agent (GTK)
    gnome-keyring
    xwayland-satellite
  ];

  # needed so polkit agent starts on login
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
