# bspwm on X11, for Charge Grinder. greetd has no X server, so the session runs startx.
# User config: modules/home/desktop/bspwm.nix
{pkgs, ...}: let
  session = pkgs.writeTextDir "share/xsessions/bspwm.desktop" ''
    [Desktop Entry]
    Name=bspwm
    Comment=bspwm on X11
    Exec=${pkgs.xinit}/bin/startx
    Type=Application
  '';
in {
  services.xserver = {
    enable = true;
    # no display manager: greetd + sysc-greet stay the greeter
    displayManager.startx = {
      enable = true;
      generateScript = true;
      # niri's session env, adjusted for X11
      extraCommands = ''
        export XDG_CURRENT_DESKTOP=bspwm
        export XDG_SESSION_TYPE=x11
        export QT_QPA_PLATFORMTHEME=gtk3 # keep in sync with qt.nix
        ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd \
          DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE QT_QPA_PLATFORMTHEME
      '';
    };
    windowManager.bspwm.enable = true;
    excludePackages = [pkgs.xterm];

    # same input as niri-config.nix
    xkb = {
      layout = "us";
      options = "ctrl:nocaps";
    };
    autoRepeatDelay = 500;
    autoRepeatInterval = 20; # 50/s
  };

  services.libinput = {
    touchpad = {
      tapping = true;
      naturalScrolling = true;
      disableWhileTyping = true;
      accelSpeed = "0.9";
    };
    mouse = {
      naturalScrolling = false;
      accelSpeed = "0.5";
    };
  };

  environment = {
    systemPackages = [session];
    pathsToLink = ["/share/xsessions"];
  };

  # xserver.enable turns this on, which sets SSH_ASKPASS to an X11 dialog in niri too
  programs.ssh.enableAskPassword = false;

  # lock screen (pam service)
  programs.i3lock.enable = true;

  # xdg-desktop-portal-gnome needs gnome-shell; the gtk portal works on X11
  xdg.portal.config.bspwm.default = ["gtk"];
}
