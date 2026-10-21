# sway session (system side: modules/nixos/desktop/sway.nix). Upstream's default config
# (Mod+hjkl, Mod+Return, Mod+d, swaybar) with only the input, outputs and game rules on top.
{
  xdg.configFile."sway/config".text = ''
    include /etc/sway/config
    # nixos.conf: pushes WAYLAND_DISPLAY etc. to dbus/systemd and starts sway-session.target
    include /etc/sway/config.d/*

    # same input as niri-config.nix
    input type:keyboard {
      xkb_layout us
      xkb_options ctrl:nocaps
      repeat_delay 500
      repeat_rate 50
    }
    input type:touchpad {
      tap enabled
      natural_scroll enabled
      dwt enabled
      pointer_accel 0.9
    }
    input type:pointer pointer_accel 0.5

    output eDP-1 position 0 0 scale 1
    output HDMI-A-1 position 1920 0 scale 1

    # upstream binds this to foot; --no-warn silences the "overwriting binding" nag
    bindsym --no-warn $mod+Return exec ghostty

    # the bot moves the mouse; with focus-follows-mouse it could hand focus to another window
    focus_follows_mouse no

    # Limbus Company (Proton): floating keeps the in-game resolution (e.g. 1280x720 windowed)
    # instead of being tiled to another size
    for_window [class="steam_app_1973530"] floating enable
  '';
}
