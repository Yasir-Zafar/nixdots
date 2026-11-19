# mango (github:mangowm/mango), the default session. Docs: https://mangowm.github.io/docs
# and docs/ in the repo. System side: modules/nixos/desktop/mango.nix.
# The home-manager module writes ~/.config/mango/config.conf and checks it with
# `mango -p` at build time, so a typo fails the build instead of the session.
#
# Look (docs/PREFERENCES.md): no shadows, no blur, no opacity, square corners, 6px gaps and
# a 2px border that marks the focused window; a window alone on a tag gets neither (it
# fills the screen). Binds copy niri-config.nix wherever mango has the same thing, and
# every bind has a plain-key version for the Everest 60 (no arrows/F-row/Print/XF86/grave).
#
# External screens (HDMI, USB-C): kanshi owns the outputs in this session. Plugging one in
# mirrors the laptop onto it (wl-mirror, fullscreen there); Mod+Ctrl+P cycles mirror ->
# extend -> external only, like Win+P. Closing the lid with a screen connected moves to
# "external only" (logind doesn't suspend while docked: nixos/services/power.nix).
#
# Tags work like dwm/awesome: a window can be on several tags, and several tags can be
# shown at once (Mod+Ctrl+N adds tag N to the view, Mod+Ctrl+Shift+N adds the window
# to tag N). Every tag starts in tile (dwm master/stack); Mod+Y opens the layout keys.
# Noctalia's recommended mango settings (layer_animations=0, exec_once) come from
# docs/user/compositor-settings/mango.mdx in noctalia.
{
  config,
  pkgs,
  lib,
  my,
  ...
}: let
  c = my.colors; # gruvbox dark medium (lib/default.nix)
  # "#rrggbb" -> mango's 0xRRGGBBAA
  hex = color: "0x${lib.removePrefix "#" color}ff";

  noctalia = args: "spawn,noctalia msg ${args}";
  wpctl = args: "spawn,wpctl ${args}";

  # Print = area to file + clipboard, Shift+Print = all outputs, Ctrl+Print = focused window
  shot = pkgs.writeShellApplication {
    name = "mango-screenshot";
    runtimeInputs = with pkgs; [grim slurp wl-clipboard jq config.wayland.windowManager.mango.package];
    text = ''
      dir=~/Pictures/Screenshots
      mkdir -p "$dir"
      file="$dir/Screenshot $(date '+%Y-%m-%d %H-%M-%S').png"
      case ''${1:-area} in
        area) geom=$(slurp) || exit 0; grim -g "$geom" "$file" ;;
        window) grim -g "$(mmsg get focusing-client | jq -r '"\(.x),\(.y) \(.width)x\(.height)"')" "$file" ;;
        screen) grim "$file" ;;
      esac
      wl-copy < "$file"
    '';
  };

  # Mod+Ctrl+P and the kanshi profiles below: mirror / extend / external (only) / next
  displayMode = pkgs.writeShellApplication {
    name = "display-mode";
    runtimeInputs = with pkgs; [kanshi wl-mirror jq libnotify procps config.wayland.windowManager.mango.package];
    text = ''
      state="''${XDG_RUNTIME_DIR:-/tmp}/display-mode"
      # the first connected output that isn't the laptop panel
      external() { mmsg get all-monitors | jq -r '.monitors[].name' | grep -vx eDP-1 | head -n1 || true; }
      saved() { cat "$state" 2>/dev/null || echo mirror; }

      case ''${1:-next} in
        mirror | extend | external) kanshictl switch "$1" ;;
        next)
          case $(saved) in
            mirror) next=extend ;;
            extend) next=external ;;
            *) next=mirror ;;
          esac
          kanshictl switch "$next"
          ;;
        # kanshi runs this after a profile is applied (also on plug-in)
        applied)
          pkill -x wl-mirror || true
          if [ "$2" = laptop ]; then exit 0; fi
          echo "$2" > "$state"
          notify-send -t 2000 -i video-display "Display: $2"
          if [ "$2" = mirror ]; then
            out=$(external)
            [ -n "$out" ] && exec wl-mirror --fullscreen-output "$out" eDP-1
          fi
          ;;
        # mango's lid switchbinds; without an external screen logind suspends instead
        lid-close) [ -n "$(external)" ] && kanshictl switch external ;;
        lid-open) [ -n "$(external)" ] && kanshictl switch "$(saved)" ;;
      esac
    '';
  };

  # Mod+Shift+/: the bind lines of the live config, searchable in less
  keys = pkgs.writeShellScript "mango-keys" ''
    grep -E '^(bind|mousebind|axisbind|gesturebind|key_mode)' ~/.config/mango/config.conf | ${pkgs.less}/bin/less
  '';

  # tag binds 1-9, dwm/awesome style
  tags = lib.concatMap (n: let
    t = toString n;
  in [
    "SUPER,${t},view,${t},0" # show only tag N (again: back to the previous tags)
    "SUPER+SHIFT,${t},tag,${t},0" # move the window to tag N
    "SUPER+CTRL,${t},toggleview,${t}" # add/remove tag N to/from the view (awesome)
    "SUPER+CTRL+SHIFT,${t},toggletag,${t}" # put the window on tag N too / take it off
  ]) (lib.range 1 9);

  # Mod+Y, then one key: pick a layout for this tag (Escape/Return leave without one)
  layouts = {
    t = "tile";
    d = "dwindle";
    g = "grid";
    m = "monocle";
    k = "deck";
    s = "scroller";
    c = "center_tile";
    v = "vertical_tile";
    f = "fair";
    r = "right_tile";
  };

  # windows that should take the whole tag: on tile they are the master (alone = full
  # screen); on a scroller tag they open full width, like niri's open-maximized
  big = [
    "^zen-beta$"
    "^firefox$"
    "^helium$"
    "^com.mitchellh.ghostty$"
    "^(Emacs|emacs)$"
    "^(Code|code)$"
    "^(Antigravity|antigravity).*"
    "^jetbrains-.*"
    "^steam_app_[0-9]+$"
    "^org.vinegarhq.Sober$"
    "^Minecraft.*"
    "^gamescope$"
  ];
  games = ["^steam_app_[0-9]+$" "^org.vinegarhq.Sober$" "^Minecraft.*" "^gamescope$"];
  float = [
    "^org.gnome.Calculator$"
    "^com.saivert.pwvucontrol$"
    "wdisplays$" # network.cycles.wdisplays
    "^polkit-.*"
    "^xdg-desktop-portal.*"
    "^com.gabm.satty$"
  ];
in {
  home.packages = [
    pkgs.wdisplays # Mod+Ctrl+Shift+P: resolution/refresh/scale by hand (until the next profile switch)
    pkgs.wl-mirror
    displayMode
  ];

  # outputs in the mango session. The first profile matching the connected screens wins on
  # plug-in, so a new screen starts mirrored. "*" = any external screen (HDMI, USB-C).
  # niri keeps its own outputs (niri-config.nix): kanshi only runs with mango.
  services.kanshi = {
    enable = true;
    systemdTarget = "mango-session.target";
    settings = let
      laptop = extra: {criteria = "eDP-1"; position = "0,0"; scale = 1.0;} // extra;
      screen = extra: {criteria = "*"; status = "enable"; scale = 1.0;} // extra;
      profile = name: outputs: {
        profile = {
          inherit name outputs;
          exec = ["${displayMode}/bin/display-mode applied ${name}"];
        };
      };
    in [
      (profile "laptop" [(laptop {status = "enable";})])
      # the external screen sits far off to the side, so the pointer can't wander onto
      # the mirror; wl-mirror covers it with the laptop's picture
      (profile "mirror" [(laptop {status = "enable";}) (screen {position = "10000,0";})])
      (profile "extend" [(laptop {status = "enable";}) (screen {position = "1920,0";})])
      (profile "external" [(laptop {status = "disable";}) (screen {position = "0,0";})])
    ];
  };

  wayland.windowManager.mango = {
    enable = true;
    # mango imports the session environment and starts mango-session.target itself
    # (set_activation_env in its main.c); this only defines the target unit, which pulls
    # in graphical-session.target (polkit agent, portals). The NixOS module doesn't link
    # mango's own copy of the unit.
    systemd.enable = true;

    settings = {
      exec_once = ["noctalia"];
      # QT_QPA_PLATFORM / NIXOS_OZONE_WL come from modules/nixos/desktop/niri.nix (session-wide)
      env = ["QT_QPA_PLATFORMTHEME,gtk3"]; # keep in sync with qt.nix

      # --- Look ---
      border_px = 2;
      no_border_when_single = 1;
      gap_inner_horizontal = 6;
      gap_inner_vertical = 6;
      gap_outer_horizontal = 6;
      gap_outer_vertical = 6;
      smart_gaps = 1; # a window alone fills the screen
      border_radius = 0;
      no_radius_when_single = 0;
      blur = 0;
      blur_layer = 0;
      shadows = 0;
      layer_shadows = 0;
      focused_opacity = 1.0;
      unfocused_opacity = 1.0;
      dim_enable = 0;
      root_color = hex c.bg;
      # also the switcher/overview frames
      focus_color = hex c.orange;
      border_color = hex c.bg2;
      urgent_color = hex c.red;
      maximized_screen_color = hex c.yellow;
      scratchpad_color = hex c.blue;
      global_color = hex c.yellow;
      overlay_color = hex c.blue;
      drop_color = "0x${lib.removePrefix "#" c.orange}80"; # where a dragged window will land
      split_color = hex c.orange;
      cursor_theme = "Bibata-Modern-Classic"; # stylix.nix
      cursor_size = 24;

      # tab bars of monocle/deck and of window groups, title bar of the switcher
      tab_bar = {
        height = 28;
        decorate = {
          fg_color = hex c.gray;
          bg_color = hex c.bg;
          focus_fg_color = hex c.fg;
          focus_bg_color = hex c.bg1;
          border_color = hex c.bg;
          border_width = 0;
          corner_radius = 0;
          font_desc = "Inter Medium 11";
        };
      };
      group_bar = {
        height = 28;
        close_button_enable = 0;
        decorate = {
          fg_color = hex c.gray;
          bg_color = hex c.bg;
          focus_fg_color = hex c.orange;
          focus_bg_color = hex c.bg1;
          border_color = hex c.bg;
          border_width = 0;
          corner_radius = 0;
          font_desc = "Inter Medium 11";
        };
      };
      title_message_bar.decorate = {
        fg_color = hex c.gray;
        bg_color = hex c.bg;
        focus_fg_color = hex c.fg;
        focus_bg_color = hex c.bg1;
        border_width = 0;
        corner_radius = 0;
        font_desc = "Inter Medium 12";
      };
      jump_label_decorate = {
        fg_color = hex c.fg;
        bg_color = hex c.bg;
        focus_fg_color = hex c.bg;
        focus_bg_color = hex c.orange;
        border_color = hex c.orange;
        border_width = 2;
        corner_radius = 0;
        font_desc = "JetBrainsMono Nerd Font Bold 16";
      };

      # --- Animations: movement only, no fades (no opacity) ---
      animations = 1;
      # noctalia animates its own panels; mango's layer animations on top of them glitch
      layer_animations = 0;
      animation_type_open = "slide";
      animation_type_close = "slide";
      animation_fade_in = 0;
      animation_fade_out = 0;
      tag_animation_direction = 0; # tags slide vertically
      animation_duration = {
        open = 220;
        close = 180;
        move = 280;
        tag = 260;
        focus = 0;
      };
      # ease-out-expo for open/move/tag, ease-in for close
      animation_curve = {
        open = "0.16,1,0.3,1";
        move = "0.16,1,0.3,1";
        tag = "0.16,1,0.3,1";
        close = "0.4,0,1,1";
        focus = "0.16,1,0.3,1";
      };

      # --- Input: same as niri-config.nix ---
      xkb_rules_layout = "us";
      xkb_rules_options = "ctrl:nocaps";
      repeat_delay = 500;
      repeat_rate = 50;
      numlock_on = 0;
      tap_to_click = 1;
      tap_and_drag = 1;
      drag_lock = 1;
      trackpad_natural_scrolling = 1;
      trackpad_disable_while_typing = 1;
      trackpad_accel_speed = 0.9;
      trackpad_scroll_factor = 0.8;
      mouse_natural_scrolling = 0;
      mouse_accel_speed = 0.5;
      axis_scroll_factor = 1.0;
      gesture_live = 1;
      device_rule = ["type:tablet,monitor:eDP-1"];

      # --- Focus and the mouse ---
      sloppy_focus = 1; # focus follows mouse
      warp_cursor = 1; # keyboard focus moves the pointer along
      cursor_hide_timeout = 5;
      cursor_hide_on_keypress = 1;
      focus_on_activate = 1;
      drag_tile_to_tile = 1; # Mod+drag a tiled window onto another to swap them
      drag_tile_small = 1;
      enable_border_resize = 1; # drag the edge between two windows to resize
      border_resize_size = 8; # grab strip: there's no border to aim at
      enable_floating_snap = 1;
      snap_distance = 30;
      # top-left corner: overview (like niri's hot corner)
      enable_hotarea = 1;
      hotarea_corner = 0;
      hotarea_size = 10;
      hotarea_disable_on_fullscreen = 1;

      # --- Tags and monitors ---
      tag_num = 9;
      view_current_to_back = 1; # Mod+N on the tag you're on goes back (niri back-and-forth)
      focus_cross_monitor = 1; # Mod+H/L walk onto the other monitor at the edge
      exchange_cross_monitor = 1;
      focus_cross_tag = 0;
      scratchpad_cross_monitor = 1;
      single_scratchpad = 1;
      scratchpad_width_ratio = 0.7;
      scratchpad_height_ratio = 0.7;
      special_dim = 0.0; # tag 0 overlay: no dimming (no opacity)
      xwayland_persistence = 1;
      sync_obj_enable = 1;
      idle_inhibit_when_fullscreen = 1; # fullscreen video/games keep the screen on
      auto_reload_config = 1;
      # no monitor_rule: kanshi (above) sets the outputs, and mango would re-apply its
      # rules on plug-in and fight it
      # lid with an external screen: move to it (and back when opened)
      switchbind = [
        "lid_on,spawn,${displayMode}/bin/display-mode lid-close"
        "lid_off,spawn,${displayMode}/bin/display-mode lid-open"
      ];

      # --- Layouts ---
      tag_rule = ["id:*,layout_name:tile"];
      circle_layout = "tile,dwindle,grid,monocle,deck,scroller";
      new_is_master = 1;
      default_master_factor = 0.55;
      default_master_count = 1;
      monocle_tab_mode = 1; # monocle = tabs (niri's tabbed column)
      monocle_no_border = 1; # one window in view: no border needed
      deck_tab_mode = 1;
      dwindle_smart_split = 1; # new window goes to the side of the focused one the cursor is on
      dwindle_smart_resize = 1;
      dwindle_preserve_split = 1;
      scroller_structs = 0;
      scroller_default_proportion = 0.5;
      scroller_proportion_preset = "0.333,0.5,0.667,1.0"; # niri's presets
      scroller_focus_center = 0;
      scroller_prefer_center = 1;
      scroller_prefer_overspread = 0;
      overview_gap_inner = 8;
      overview_gap_outer = 24;
      title_message_bar_height = 44;

      # --- Window rules ---
      window_rule =
        map (id: "scroller_proportion:1.0,app_id:${id}") big
        ++ map (id: "idle_inhibit_when_focus:1,app_id:${id}") games
        ++ map (id: "is_floating:1,app_id:${id}") float
        ++ [
          # swallowing (dwm): a GUI app started from a terminal takes the terminal's place
          "is_term:1,app_id:^com.mitchellh.ghostty$"
          "no_swallow:1,app_id:^(zen-beta|firefox|helium)$"
          "is_floating:1,width:0.5,height:0.7,title:^mango-keys$"
          # noctalia's settings window
          "is_floating:1,width:1080,height:920,app_id:^dev.noctalia.Noctalia$"
          # picture-in-picture: small, bottom-right, on every tag, no focus steal
          "is_floating:1,is_global:1,is_open_silent:1,width:480,height:270,offset_x:95,offset_y:90,app_id:^zen-beta$,title:^Picture-in-Picture$"
          # steam toasts: bottom-right, never stealing focus from the game
          "is_floating:1,is_open_silent:1,offset_x:100,offset_y:100,app_id:^steam$,title:^notificationtoasts_[0-9]+_desktop$"
          # the mirror on the external screen (display-mode): focus stays on the laptop
          "is_open_silent:1,no_animation:1,no_border:1,app_id:^at.yrlf.wl_mirror$"
          # quake terminal (Mod+D)
          "is_named_scratchpad:1,width:0.7,height:0.6,offset_y:-40,app_id:^ghostty.scratch$"
        ];

      # --- Layer rules ---
      layer_rule = [
        # notifications stay out of screen shares and recordings
        "shield_when_capture:1,no_animation:1,layer_name:^noctalia-notification"
        "no_blur:1,no_shadow:1,layer_name:^noctalia-"
        # slurp's selection: no animation, so it isn't in the screenshot
        "no_animation:1,no_blur:1,layer_name:^selection$"
      ];

      # --- Key binds (SUPER = Mod) ---
      bindn = [
        "SUPER,q,killclient"
      ];
      # work on the lock screen too: volume, brightness, media
      bindl = [
        "NONE,XF86AudioRaiseVolume,${wpctl "set-volume @DEFAULT_AUDIO_SINK@ 5%+"}"
        "NONE,XF86AudioLowerVolume,${wpctl "set-volume @DEFAULT_AUDIO_SINK@ 5%-"}"
        "NONE,XF86AudioMute,${wpctl "set-mute @DEFAULT_AUDIO_SINK@ toggle"}"
        "NONE,XF86AudioMicMute,${wpctl "set-mute @DEFAULT_AUDIO_SOURCE@ toggle"}"
        "NONE,XF86MonBrightnessUp,spawn,brightnessctl set 10%+"
        "NONE,XF86MonBrightnessDown,spawn,brightnessctl set 10%-"
        "NONE,XF86AudioPlay,spawn,playerctl play-pause"
        "NONE,XF86AudioNext,spawn,playerctl next"
        "NONE,XF86AudioPrev,spawn,playerctl previous"
        # same without Fn (60% keyboard), as in niri
        "SUPER+ALT,k,${wpctl "set-volume @DEFAULT_AUDIO_SINK@ 5%+"}"
        "SUPER+ALT,j,${wpctl "set-volume @DEFAULT_AUDIO_SINK@ 5%-"}"
        "SUPER+ALT,m,${wpctl "set-mute @DEFAULT_AUDIO_SINK@ toggle"}"
        "SUPER+ALT,space,spawn,playerctl play-pause"
        "SUPER+ALT,l,spawn,playerctl next"
        "SUPER+ALT,h,spawn,playerctl previous"
        "SUPER+ALT,equal,spawn,brightnessctl set 10%+"
        "SUPER+ALT,minus,spawn,brightnessctl set 10%-"
      ];

      bind =
        [
          # session
          "SUPER+SHIFT,e,quit"
          "SUPER+SHIFT,c,reload_config" # mostly not needed: the config reloads on change
          "SUPER+SHIFT,p,${noctalia "dpms-off"}"
          "SUPER+SHIFT,slash,spawn,ghostty --title=mango-keys -e ${keys}"

          # applications
          "SUPER,Return,spawn,ghostty"
          "SUPER+SHIFT,Return,spawn,ghostty -e nvim"
          "SUPER,w,spawn,zen-beta"
          "SUPER,e,spawn,nautilus"
          "SUPER+SHIFT,u,spawn,ghostty --title=nx -e nx tui"
          "CTRL+SHIFT,Escape,spawn,missioncenter"
          "SUPER,x,spawn,way-clicker --nogui --toggle"
          "SUPER+CTRL,p,spawn,${displayMode}/bin/display-mode next" # mirror -> extend -> external, like Win+P
          "SUPER+CTRL+SHIFT,p,spawn,wdisplays" # resolution, refresh, scale by hand
          "SUPER,d,toggle_named_scratchpad,ghostty.scratch,none,ghostty --class=ghostty.scratch --gtk-single-instance=false"

          # noctalia (`noctalia msg --help`)
          "SUPER,space,${noctalia "panel-toggle launcher"}"
          "SUPER,p,${noctalia "panel-toggle launcher"}"
          "SUPER,semicolon,${noctalia "panel-toggle launcher /emo"}"
          "SUPER,v,${noctalia "panel-toggle clipboard"}"
          "SUPER,a,${noctalia "panel-toggle control-center"}"
          "SUPER,Escape,${noctalia "panel-toggle session"}"
          "SUPER+SHIFT,Escape,${noctalia "session lock"}"
          "SUPER,b,${noctalia "power-cycle"}"
          "SUPER,i,${noctalia "caffeine-toggle"}"
          "SUPER+SHIFT,n,${noctalia "notification-dnd-toggle"}"
          "SUPER+SHIFT,b,${noctalia "bar-toggle"}"
          # hold: a quick tap switches straight to the previous window
          "ALT,Tab,${noctalia "window-switcher hold"}"

          # overview and switching
          "SUPER,Tab,toggleoverview"
          "SUPER+SHIFT,Tab,toggleoverview,1" # only the tags in view
          "SUPER,o,togglejump" # a letter on every window: press it to focus that one
          # windows of this tag, with thumbnails (grave is behind Fn on the Everest 60)
          "SUPER,g,switcher,next"
          "SUPER+SHIFT,g,switcher,prev"

          # screenshots (Print is Fn+K on the Everest 60; Mod+Shift+S is the plain one)
          "NONE,Print,spawn,${shot}/bin/mango-screenshot area"
          "SHIFT,Print,spawn,${shot}/bin/mango-screenshot screen"
          "CTRL,Print,spawn,${shot}/bin/mango-screenshot window"
          ''SUPER+SHIFT,s,spawn_shell,grim -g "$(slurp)" - | satty --filename - --output-filename ~/Pictures/Screenshots/satty-$(date +%F_%H-%M-%S).png''

          # focus (vim keys + arrows)
          "SUPER,h,focusdir,left"
          "SUPER,l,focusdir,right"
          "SUPER,j,focusdir,down"
          "SUPER,k,focusdir,up"
          "SUPER,Left,focusdir,left"
          "SUPER,Right,focusdir,right"
          "SUPER,Down,focusdir,down"
          "SUPER,Up,focusdir,up"
          "SUPER,n,focusstack,next" # dwm Mod+J/K: walk the stack in order
          "SUPER+SHIFT,o,focuslast"
          # move windows around inside the tag: swap with the neighbour
          "SUPER+SHIFT,h,exchange_client,left"
          "SUPER+SHIFT,l,exchange_client,right"
          "SUPER+SHIFT,j,exchange_client,down"
          "SUPER+SHIFT,k,exchange_client,up"
          "SUPER+SHIFT,Left,exchange_client,left"
          "SUPER+SHIFT,Right,exchange_client,right"
          "SUPER+SHIFT,Down,exchange_client,down"
          "SUPER+SHIFT,Up,exchange_client,up"
          "SUPER,z,zoom" # dwm: swap with the master

          # sharing a tag: master size and count (tile, center_tile, deck…)
          "SUPER,minus,setmfact,-0.05"
          "SUPER,equal,setmfact,+0.05"
          "SUPER+SHIFT,minus,incnmaster,-1"
          "SUPER+SHIFT,equal,incnmaster,+1"
          "SUPER,r,switch_proportion_preset" # scroller tags: 1/3, 1/2, 2/3, full
          "SUPER+SHIFT,r,dwindle_toggle_current_split" # dwindle tags: flip this split

          # groups: windows stacked in one tile with a tab bar (awesome/i3 tabs)
          "SUPER,comma,groupfocus,prev"
          "SUPER,period,groupfocus,next"
          "SUPER+SHIFT,comma,groupjoin,left"
          "SUPER+SHIFT,period,groupjoin,right"
          "SUPER+CTRL,comma,groupjoin,up"
          "SUPER+CTRL,period,groupjoin,down"
          "SUPER,slash,groupleave"

          # layouts
          "SUPER,y,setkeymode,layout" # then t/d/g/m/k/s/c/v/f/r, see key_mode below
          "SUPER+SHIFT,y,switch_layout" # cycle tile → dwindle → grid → monocle → deck → scroller
          "SUPER+SHIFT,t,setlayout,monocle" # tabbed, like niri's Mod+Shift+T

          # window state
          "SUPER,f,togglemaximizescreen" # cover the tag (bar stays)
          "SUPER+SHIFT,f,togglefullscreen"
          "SUPER+CTRL,f,togglefakefullscreen" # the app thinks it's fullscreen, stays in its tile
          "SUPER,t,togglefloating"
          "SUPER,c,centerwin"
          "SUPER+SHIFT,v,toggleoverlay" # keep on top
          "SUPER+SHIFT,0,toggleglobal" # sticky: on every tag
          "SUPER,m,minimized" # hide in the scratchpad
          "SUPER+SHIFT,m,restore_minimized"
          "SUPER+CTRL,m,toggle_scratchpad"
          "SUPER,s,toggle_special_tag" # tag 0: a tiled overlay over any tag
          "SUPER+CTRL,s,tag_special_tag" # move the window to/from tag 0

          # tags
          "SUPER,0,view,00" # every tag at once (dwm Mod+0)
          "SUPER,bracketleft,viewtoleft_have_client,0"
          "SUPER,bracketright,viewtoright_have_client,0"
          "SUPER+SHIFT,bracketleft,tagtoleft,0"
          "SUPER+SHIFT,bracketright,tagtoright,0"
          "SUPER,backslash,view_insert,next" # an empty tag next to this one

          # monitors (laptop + HDMI): Ctrl = monitor, Ctrl+Shift = take the window there
          "SUPER+CTRL,h,focusmon,left"
          "SUPER+CTRL,l,focusmon,right"
          "SUPER+CTRL,Left,focusmon,left"
          "SUPER+CTRL,Right,focusmon,right"
          "SUPER+CTRL+SHIFT,h,tagmon,left,0"
          "SUPER+CTRL+SHIFT,l,tagmon,right,0"
          "SUPER+CTRL+SHIFT,Left,tagmon,left,0"
          "SUPER+CTRL+SHIFT,Right,tagmon,right,0"
        ]
        ++ tags;

      # --- Mouse ---
      mousebind = [
        "SUPER,btn_left,moveresize,curmove" # drag: float it, or drop it on a tile to swap
        "SUPER,btn_right,moveresize,curresize"
        "SUPER,btn_middle,togglemaximizescreen"
        "SUPER+SHIFT,btn_left,togglefloating"
        "SUPER+CTRL,btn_right,killclient"
        # side buttons with Mod: previous / next tag
        "SUPER,btn_side,viewtoleft_have_client,0"
        "SUPER,btn_extra,viewtoright_have_client,0"
      ];
      axisbind = [
        "SUPER,UP,viewtoleft_have_client,0"
        "SUPER,DOWN,viewtoright_have_client,0"
        "SUPER,LEFT,focusdir,left"
        "SUPER,RIGHT,focusdir,right"
        "SUPER+SHIFT,UP,tagtoleft,0"
        "SUPER+SHIFT,DOWN,tagtoright,0"
        "SUPER+CTRL,UP,focusstack,prev"
        "SUPER+CTRL,DOWN,focusstack,next"
        "SUPER+ALT,UP,${wpctl "set-volume @DEFAULT_AUDIO_SINK@ 5%+"}"
        "SUPER+ALT,DOWN,${wpctl "set-volume @DEFAULT_AUDIO_SINK@ 5%-"}"
      ];
      # touchpad: 3 fingers move focus, 4 fingers switch tags / open the overview
      gesturebind = [
        "none,left,3,focusdir,left"
        "none,right,3,focusdir,right"
        "none,up,3,focusdir,up"
        "none,down,3,focusdir,down"
        "none,right,4,viewprev_have_client"
        "none,left,4,viewnext_have_client"
        "none,up,4,enteroverview"
        "none,down,4,leaveoverview"
      ];

      key_mode.layout = {
        bindc =
          lib.concatLists (lib.mapAttrsToList (key: layout: [
              "NONE,${key},setlayout,${layout}"
              "NONE,${key},setkeymode,default"
            ])
            layouts)
          ++ [
            "NONE,Escape,setkeymode,default"
            "NONE,Return,setkeymode,default"
          ];
      };
    };
  };
}
