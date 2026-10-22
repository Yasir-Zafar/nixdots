# bspwm session (system side: modules/nixos/desktop/bspwm.nix), set up to feel like niri:
# same binds where bspwm has an equivalent, no gaps/borders/shadows, Gruvbox.
# Noctalia is Wayland-only, so on X11 its jobs are done by:
#   bar: polybar   launcher/emoji/window switcher: rofi   clipboard: clipmenu
#   notifications: dunst   lock/idle: xss-lock + i3lock   session/power/caffeine: scripts below
# The X11 tools are started from bspwmrc by store path rather than installed: a dunst on
# PATH would be D-Bus activated in niri before noctalia claims notifications.
{
  config,
  pkgs,
  my,
  ...
}: let
  # gruvbox dark medium
  c = {
    bg = "#282828";
    bg1 = "#3c3836";
    bg2 = "#504945";
    fg = "#ebdbb2";
    gray = "#928374";
    red = "#fb4934";
    yellow = "#fabd2f";
    orange = "#fe8019";
  };

  rofi = "${config.programs.rofi.finalPackage}/bin/rofi";
  dunstctl = "${pkgs.dunst}/bin/dunstctl";

  # same timings as noctalia's idle settings: screen off at 7 min, lock at 10
  idle = "xset s 600 600; xset +dpms; xset dpms 420 420 420";
  lock = "i3lock -n -c ${builtins.substring 1 6 c.bg}";

  # Mod+Escape, noctalia's session menu
  session-menu = pkgs.writeShellApplication {
    name = "bspwm-session-menu";
    runtimeInputs = [pkgs.bspwm];
    text = ''
      choice=$(printf '%s\n' Lock Logout Suspend Reboot Shutdown | ${rofi} -dmenu -i -p session) || exit 0
      case $choice in
        Lock) loginctl lock-session ;;
        Logout) bspc quit ;;
        Suspend) systemctl suspend ;;
        Reboot) systemctl reboot ;;
        Shutdown) systemctl poweroff ;;
      esac
    '';
  };

  # Mod+I: no screen off / lock while on
  caffeine = pkgs.writeShellApplication {
    name = "bspwm-caffeine";
    runtimeInputs = [pkgs.xset pkgs.libnotify];
    text = ''
      if xset q | grep -q "DPMS is Enabled"; then
        xset s off -dpms
        notify-send -t 2000 Caffeine on
      else
        ${idle}
        notify-send -t 2000 Caffeine off
      fi
    '';
  };

  # Mod+B: balanced -> performance -> power-saver (tuned's ppd service)
  power-cycle = pkgs.writeShellApplication {
    name = "bspwm-power-cycle";
    runtimeInputs = [pkgs.power-profiles-daemon pkgs.libnotify];
    text = ''
      case $(powerprofilesctl get) in
        balanced) next=performance ;;
        performance) next=power-saver ;;
        *) next=balanced ;;
      esac
      powerprofilesctl set "$next"
      notify-send -t 2000 "Power profile" "$next"
    '';
  };

  # same files as niri's screenshot-path; also copied to the clipboard
  screenshot = pkgs.writeShellApplication {
    name = "bspwm-screenshot";
    runtimeInputs = with pkgs; [maim xdotool xclip satty libnotify];
    text = ''
      dir=~/Pictures/Screenshots
      mkdir -p "$dir"
      file="$dir/Screenshot $(date '+%Y-%m-%d %H-%M-%S').png"
      case ''${1:-} in
        area) maim -s -u "$file" ;;
        window) maim -u -i "$(xdotool getactivewindow)" "$file" ;;
        screen) maim -u "$file" ;;
        annotate)
          maim -s -u | satty --filename - --output-filename "$dir/satty-$(date +%F_%H-%M-%S).png"
          exit
          ;;
      esac
      xclip -selection clipboard -t image/png < "$file"
      notify-send -t 3000 -i "$file" Screenshot "$(basename "$file")"
    '';
  };

  polybar = pkgs.polybar.override {pulseSupport = true;};
in {
  xsession.windowManager.bspwm = {
    enable = true;

    # outputs as in niri-config.nix (X calls HDMI-A-1 "HDMI-1"); 5 desktops per monitor,
    # like niri's per-monitor workspaces. After plugging a monitor in: Mod+Ctrl+R.
    extraConfigEarly = ''
      xrandr --output eDP-1 --primary --auto --pos 0x0 --output HDMI-1 --auto --right-of eDP-1
      for m in $(bspc query -M --names); do
        bspc monitor "$m" -d 1 2 3 4 5
      done
    '';

    settings = {
      # niri: no gaps, no border, no focus ring
      border_width = 0;
      window_gap = 0;
      split_ratio = 0.5;
      borderless_monocle = true;
      gapless_monocle = true;
      single_monocle = false;

      # niri's warp-mouse-to-focus. focus_follows_pointer stays off (niri has it on):
      # Charge Grinder moves the mouse and would hand focus to another window
      pointer_follows_focus = true;
      pointer_follows_monitor = true;
      focus_follows_pointer = false;

      remove_disabled_monitors = true;
      remove_unplugged_monitors = true;
      merge_overlapping_monitors = true;
    };

    rules = {
      # Limbus Company (Proton): floating keeps the in-game resolution (e.g. 1280x720 windowed)
      "steam_app_1973530".state = "floating";
      # Zen/Firefox picture-in-picture
      "*:Toolkit" = {
        state = "floating";
        sticky = true;
      };
      "Pavucontrol".state = "floating";
    };

    # runs again on `bspc wm -r`, so daemons only start once and polybar is restarted
    extraConfig = ''
      once() { pgrep -f "$1" >/dev/null || "$@" & }

      xsetroot -cursor_name left_ptr
      ${pkgs.feh}/bin/feh --no-fehbg --bg-fill ${my.assets + "/wall.jpg"}
      ${idle}

      once ${pkgs.picom}/bin/picom
      once ${pkgs.dunst}/bin/dunst
      once ${pkgs.clipmenu}/bin/clipmenud
      # niri's cursor.hide-when-typing
      once ${pkgs.xbanish}/bin/xbanish
      # locks on idle (xset s), before suspend and on `loginctl lock-session`
      once ${pkgs.xss-lock}/bin/xss-lock -l -- ${lock}

      pkill -x polybar
      for m in $(bspc query -M --names); do
        MONITOR=$m ${polybar}/bin/polybar main &
      done
    '';
  };

  # sxhkd itself is started by the session (nixos xinitrc)
  services.sxhkd = {
    enable = true;
    keybindings = {
      # session
      "super + shift + e" = "bspc quit";
      "super + shift + p" = "sleep 0.5; xset dpms force off";
      "super + ctrl + r" = "bspc wm -r";

      # applications
      "super + Return" = "ghostty";
      "super + shift + Return" = "ghostty -e nvim";
      "super + w" = "zen-beta";
      "super + e" = "nautilus";
      "super + shift + u" = "ghostty --title=nx -e nx tui";
      "ctrl + shift + Escape" = "missioncenter";

      # noctalia equivalents
      "super + {space,p}" = "${rofi} -show drun";
      "super + semicolon" = "${rofi} -show emoji";
      "alt + Tab" = "${rofi} -show window";
      "super + v" = "CM_LAUNCHER=rofi ${pkgs.clipmenu}/bin/clipmenu";
      "super + a" = "pavucontrol";
      "super + Escape" = "${session-menu}/bin/bspwm-session-menu";
      "super + shift + Escape" = "loginctl lock-session";
      "super + b" = "${power-cycle}/bin/bspwm-power-cycle";
      "super + i" = "${caffeine}/bin/bspwm-caffeine";
      "super + shift + n" = "${dunstctl} set-paused toggle";
      "super + shift + b" = "${polybar}/bin/polybar-msg cmd toggle";

      # screenshots
      "Print" = "${screenshot}/bin/bspwm-screenshot area";
      "shift + Print" = "${screenshot}/bin/bspwm-screenshot screen";
      "ctrl + Print" = "${screenshot}/bin/bspwm-screenshot window";
      "super + shift + s" = "${screenshot}/bin/bspwm-screenshot annotate";

      # focus / move (vim keys + arrows)
      "super + {h,j,k,l}" = "bspc node -f {west,south,north,east}";
      "super + {Left,Down,Up,Right}" = "bspc node -f {west,south,north,east}";
      "super + shift + {h,j,k,l}" = "bspc node -s {west,south,north,east}";
      "super + shift + {Left,Down,Up,Right}" = "bspc node -s {west,south,north,east}";
      "super + Tab" = "bspc desktop -f last.local";

      # monitors: Ctrl = monitor, Ctrl+Shift = take the window there
      "super + ctrl + {h,l,Left,Right}" = "bspc monitor -f {west,east,west,east}";
      "super + ctrl + shift + {h,l,Left,Right}" = "bspc node -m {west,east,west,east} --follow";

      # desktops of the focused monitor; pressing the current one goes back (back-and-forth)
      "super + {1-5}" = "bspc desktop -f focused:^{1-5}.!focused || bspc desktop -f last.local";
      "super + shift + {1-5}" = "bspc node -d focused:^{1-5}";
      "super + {bracketleft,bracketright}" = "bspc desktop -f {prev,next}.local";
      "super + shift + {bracketleft,bracketright}" = "bspc node -d {prev,next}.local --follow";
      "super + {button4,button5}" = "bspc desktop -f {prev,next}.local";

      # sizing: Minus/Equal = width, Shift = height
      "super + {minus,equal}" = "bspc node -z {right -40 0,right 40 0} || bspc node -z {left 40 0,left -40 0}";
      "super + shift + {minus,equal}" = "bspc node -z {bottom 0 -40,bottom 0 40} || bspc node -z {top 0 40,top 0 -40}";
      "super + r" = "bspc node @parent -R 90";
      "super + shift + r" = "bspc node @/ -B";

      # window state
      "super + q" = "bspc node -c";
      "super + f" = "bspc desktop -l next";
      "super + shift + f" = "bspc node -t ~fullscreen";
      "super + t" = "bspc node -t ~floating";
      "super + shift + v" = "bspc query -N -n focused.floating >/dev/null && bspc node -f last.local.tiled || bspc node -f any.local.floating";

      # media keys
      "XF86AudioRaiseVolume" = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
      "XF86AudioLowerVolume" = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
      "XF86AudioMute" = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      "XF86AudioMicMute" = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
      "XF86MonBrightnessUp" = "brightnessctl set 10%+";
      "XF86MonBrightnessDown" = "brightnessctl set 10%-";
      "XF86AudioPlay" = "playerctl play-pause";
      "XF86AudioNext" = "playerctl next";
      "XF86AudioPrev" = "playerctl previous";
    };
  };

  # rofi 2 also runs on Wayland, so it's fine on PATH; themed by stylix (stylix.nix)
  programs.rofi = {
    enable = true;
    plugins = [pkgs.rofi-emoji];
    settings = {
      modi = "drun,window,emoji";
      show-icons = true;
      drun-display-format = "{name}";
    };
  };

  xdg.configFile = {
    # no shadows or rounding (niri-config.nix); vsync and short fades like niri's 150ms
    "picom/picom.conf".text = ''
      backend = "glx";
      vsync = true;
      shadow = false;
      corner-radius = 0;
      fading = true;
      fade-in-step = 0.1;
      fade-out-step = 0.1;
      fade-delta = 10;
      unredir-if-possible = true;
    '';

    "dunst/dunstrc".text = ''
      [global]
      font = Inter 11
      origin = top-right
      offset = (10, 10)
      width = 350
      frame_width = 0
      corner_radius = 0
      separator_color = frame
      icon_theme = Gruvbox-Plus-Dark
      enable_recursive_icon_lookup = true
      background = "${c.bg1}"
      foreground = "${c.fg}"

      [urgency_low]
      timeout = 4

      [urgency_normal]
      timeout = 6

      [urgency_critical]
      foreground = "${c.red}"
      timeout = 0
    '';

    # one bar per monitor (MONITOR from bspwmrc), noctalia's widgets laid out on a top bar
    "polybar/config.ini".text = ''
      [bar/main]
      monitor = ''${env:MONITOR:}
      height = 26
      background = ${c.bg}
      foreground = ${c.fg}
      font-0 = JetBrainsMono Nerd Font:size=11;3
      padding-right = 1
      module-margin = 1
      modules-left = launcher date cpu memory title
      modules-center = desktops
      modules-right = tray network pulseaudio backlight battery
      wm-restack = bspwm
      enable-ipc = true

      [module/launcher]
      type = custom/text
      format = " "
      format-foreground = ${c.orange}
      click-left = ${rofi} -show drun

      [module/date]
      type = internal/date
      date = %H:%M %a, %b %d

      [module/cpu]
      type = internal/cpu
      label = "󰻠 %percentage%%"

      [module/memory]
      type = internal/memory
      label = "󰍛 %percentage_used%%"

      [module/title]
      type = internal/xwindow
      label = %title:0:40:…%
      label-foreground = ${c.gray}

      [module/desktops]
      type = internal/bspwm
      pin-workspaces = true
      label-focused = %name%
      label-focused-foreground = ${c.bg}
      label-focused-background = ${c.yellow}
      label-focused-padding = 1
      label-occupied = %name%
      label-occupied-padding = 1
      label-empty = %name%
      label-empty-foreground = ${c.bg2}
      label-empty-padding = 1
      label-urgent = %name%
      label-urgent-foreground = ${c.red}
      label-urgent-padding = 1

      [module/tray]
      type = internal/tray
      tray-spacing = 6

      [module/network]
      type = internal/network
      interface-type = wireless
      label-connected = "󰖩 %essid%"
      label-disconnected = "󰖪"
      label-disconnected-foreground = ${c.gray}

      [module/pulseaudio]
      type = internal/pulseaudio
      label-volume = "󰕾 %percentage%%"
      label-muted = "󰖁 muted"
      label-muted-foreground = ${c.gray}
      click-right = pavucontrol

      [module/backlight]
      type = internal/backlight
      card = intel_backlight
      use-actual-brightness = true
      label = "󰃠 %percentage%%"

      [module/battery]
      type = internal/battery
      battery = BAT1
      adapter = ACAD
      full-at = 99
      label-charging = "󰂄 %percentage%%"
      label-discharging = "󰁹 %percentage%%"
      label-full = "󰁹 full"
    '';
  };
}
