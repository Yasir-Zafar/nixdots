# mango (github:mangowm/mango), the default session. System side: nixos/desktop/mango.nix.
# Only options that differ from mango's defaults. Binds follow niri-config.nix, each
# with a plain-key version for the 60% board.
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

  # --- Key binds, with the text Mod+Shift+/ shows ---
  # b: a bind and its description; l: same, also on the lock screen; n: no key repeat;
  # h: bound but not listed (arrow twins); note: listed only (summary rows, mouse…)
  b = desc: line: {
    inherit desc line;
    kind = "bind";
  };
  l = desc: line: {
    inherit desc line;
    kind = "bindl";
  };
  n = desc: line: {
    inherit desc line;
    kind = "bindn";
  };
  h = line: {
    desc = null;
    inherit line;
    kind = "bind";
  };
  hl = line: {
    desc = null;
    inherit line;
    kind = "bindl";
  };
  note = keys: desc: {
    inherit keys desc;
    line = null;
    kind = "note";
  };

  # "SUPER+SHIFT,bracketleft,…" -> "Mod+Shift+["
  pretty = line: let
    parts = lib.splitString "," (builtins.unsafeDiscardStringContext line);
    mods = lib.filter (m: m != "NONE") (lib.splitString "+" (builtins.head parts));
    key = builtins.elemAt parts 1;
    modName = {
      SUPER = "Mod";
      CTRL = "Ctrl";
      ALT = "Alt";
      SHIFT = "Shift";
    };
    keyName = {
      Return = "Enter";
      Escape = "Esc";
      space = "Space";
      Tab = "Tab";
      Print = "Print";
      bracketleft = "[";
      bracketright = "]";
      minus = "-";
      equal = "=";
      comma = ",";
      period = ".";
      slash = "/";
      semicolon = ";";
      backslash = "\\";
    };
    k =
      keyName.${
        key
      } or (
        if builtins.stringLength key == 1
        then lib.toUpper key
        else key
      );
  in
    lib.concatStringsSep "+" (map (m: modName.${m} or m) mods ++ [k]);

  sheet = [
    {
      title = "Apps";
      binds = [
        (b "terminal" "SUPER,Return,spawn,ghostty")
        (b "nvim in a terminal" "SUPER+SHIFT,Return,spawn,ghostty -e nvim")
        (b "drop-down terminal (show/hide)" "SUPER,d,toggle_named_scratchpad,ghostty.scratch,none,ghostty --class=ghostty.scratch --gtk-single-instance=false")
        (b "Zen" "SUPER,w,spawn,zen-beta")
        (b "files" "SUPER,e,spawn,nautilus")
        (b "nx tui (updates, apps, storage)" "SUPER+SHIFT,u,spawn,ghostty --title=nx -e nx tui")
        (b "Mission Center" "CTRL+SHIFT,Escape,spawn,missioncenter")
        (b "autoclicker start/stop" "SUPER,x,spawn,way-clicker --nogui --toggle")
      ];
    }
    {
      title = "Noctalia";
      binds = [
        (b "launcher" "SUPER,space,${noctalia "panel-toggle launcher"}")
        (b "launcher" "SUPER,p,${noctalia "panel-toggle launcher"}")
        (b "emoji picker" "SUPER,semicolon,${noctalia "panel-toggle launcher /emo"}")
        (b "clipboard history" "SUPER,v,${noctalia "panel-toggle clipboard"}")
        (b "control center" "SUPER,a,${noctalia "panel-toggle control-center"}")
        (b "session menu (logout, reboot…)" "SUPER,Escape,${noctalia "panel-toggle session"}")
        (b "lock screen" "SUPER+SHIFT,Escape,${noctalia "session lock"}")
        (b "next power profile" "SUPER,b,${noctalia "power-cycle"}")
        (b "caffeine (no sleep) on/off" "SUPER,i,${noctalia "caffeine-toggle"}")
        (b "do-not-disturb on/off" "SUPER+SHIFT,n,${noctalia "notification-dnd-toggle"}")
        (b "hide/show the bar" "SUPER+SHIFT,b,${noctalia "bar-toggle"}")
        (b "window switcher (tap: previous window)" "ALT,Tab,${noctalia "window-switcher hold"}")
      ];
    }
    {
      title = "Focus and moving windows (this tag)";
      binds = [
        (note "Mod+H J K L" "focus left / down / up / right (arrows work too)")
        (h "SUPER,h,focusdir,left")
        (h "SUPER,l,focusdir,right")
        (h "SUPER,j,focusdir,down")
        (h "SUPER,k,focusdir,up")
        (h "SUPER,Left,focusdir,left")
        (h "SUPER,Right,focusdir,right")
        (h "SUPER,Down,focusdir,down")
        (h "SUPER,Up,focusdir,up")
        (note "Mod+Shift+H J K L" "swap with the window in that direction (arrows too)")
        (h "SUPER+SHIFT,h,exchange_client,left")
        (h "SUPER+SHIFT,l,exchange_client,right")
        (h "SUPER+SHIFT,j,exchange_client,down")
        (h "SUPER+SHIFT,k,exchange_client,up")
        (h "SUPER+SHIFT,Left,exchange_client,left")
        (h "SUPER+SHIFT,Right,exchange_client,right")
        (h "SUPER+SHIFT,Down,exchange_client,down")
        (h "SUPER+SHIFT,Up,exchange_client,up")
        (b "swap with the big (master) window" "SUPER,z,zoom")
        (b "next window in order" "SUPER,n,focusstack,next")
        (b "back to the last focused window" "SUPER+SHIFT,o,focuslast")
        (b "jump: press the letter shown on a window" "SUPER,o,togglejump")
        (b "switcher with previews (this tag)" "SUPER,g,switcher,next")
        (b "switcher, backwards" "SUPER+SHIFT,g,switcher,prev")
        (b "overview of all tags" "SUPER,Tab,toggleoverview")
        (b "overview of the tags in view" "SUPER+SHIFT,Tab,toggleoverview,1")
        (n "close window" "SUPER,q,killclient")
      ];
    }
    {
      title = "Sizes and layouts";
      binds = [
        (b "big (master) area smaller" "SUPER,minus,setmfact,-0.05")
        (b "big (master) area bigger" "SUPER,equal,setmfact,+0.05")
        (b "one big window less" "SUPER+SHIFT,minus,incnmaster,-1")
        (b "one big window more" "SUPER+SHIFT,equal,incnmaster,+1")
        (b "layout menu: then T D G M K S C V F R (Esc: cancel)" "SUPER,y,setkeymode,layout")
        (b "next layout" "SUPER+SHIFT,y,switch_layout")
        (b "tabs layout (monocle)" "SUPER+SHIFT,t,setlayout,monocle")
        (b "scroller layout: next width" "SUPER,r,switch_proportion_preset")
        (b "dwindle layout: flip this split" "SUPER+SHIFT,r,dwindle_toggle_current_split")
        (b "maximize over the tag" "SUPER,f,togglemaximizescreen")
        (b "fullscreen" "SUPER+SHIFT,f,togglefullscreen")
        (b "fake fullscreen (stays in its tile)" "SUPER+CTRL,f,togglefakefullscreen")
        (b "float / tile" "SUPER,t,togglefloating")
        (b "center the floating window" "SUPER,c,centerwin")
        (b "keep on top" "SUPER+SHIFT,v,toggleoverlay")
      ];
    }
    {
      title = "Tabs inside a tile (groups)";
      binds = [
        (b "join the window on the left as a tab" "SUPER+SHIFT,comma,groupjoin,left")
        (b "join the window on the right as a tab" "SUPER+SHIFT,period,groupjoin,right")
        (b "join the window above as a tab" "SUPER+CTRL,comma,groupjoin,up")
        (b "join the window below as a tab" "SUPER+CTRL,period,groupjoin,down")
        (b "previous tab" "SUPER,comma,groupfocus,prev")
        (b "next tab" "SUPER,period,groupfocus,next")
        (b "take the window out of the tabs" "SUPER,slash,groupleave")
      ];
    }
    {
      title = "Tags";
      binds = [
        (note "Mod+1…9" "show tag N (press again: back)")
        (note "Mod+Shift+1…9" "move the window to tag N")
        (note "Mod+Ctrl+1…9" "also show tag N (several tags at once)")
        (note "Mod+Ctrl+Shift+1…9" "also put the window on tag N")
        (b "show every tag" "SUPER,0,view,00")
        (b "window on every tag (sticky)" "SUPER+SHIFT,0,toggleglobal")
        (b "previous tag with windows" "SUPER,bracketleft,viewtoleft_have_client,0")
        (b "next tag with windows" "SUPER,bracketright,viewtoright_have_client,0")
        (b "move the window one tag left" "SUPER+SHIFT,bracketleft,tagtoleft,0")
        (b "move the window one tag right" "SUPER+SHIFT,bracketright,tagtoright,0")
        (b "go to a new empty tag" "SUPER,backslash,view_insert,next")
        (b "overlay tag 0 (show/hide)" "SUPER,s,toggle_special_tag")
        (b "move the window to/from the overlay tag" "SUPER+CTRL,s,tag_special_tag")
        (b "hide the window (scratchpad)" "SUPER,m,minimized")
        (b "bring the hidden window back" "SUPER+SHIFT,m,restore_minimized")
        (b "show/hide the scratchpad" "SUPER+CTRL,m,toggle_scratchpad")
      ];
    }
    {
      title = "Monitors";
      binds = [
        (b "focus the monitor on the left" "SUPER+CTRL,h,focusmon,left")
        (b "focus the monitor on the right" "SUPER+CTRL,l,focusmon,right")
        (h "SUPER+CTRL,Left,focusmon,left")
        (h "SUPER+CTRL,Right,focusmon,right")
        (b "move the window to the left monitor" "SUPER+CTRL+SHIFT,h,tagmon,left,0")
        (b "move the window to the right monitor" "SUPER+CTRL+SHIFT,l,tagmon,right,0")
        (h "SUPER+CTRL+SHIFT,Left,tagmon,left,0")
        (h "SUPER+CTRL+SHIFT,Right,tagmon,right,0")
        (b "external screen: mirror -> extend -> only external" "SUPER+CTRL,p,spawn,${displayMode}/bin/display-mode next")
        (b "screen settings (resolution, scale)" "SUPER+CTRL+SHIFT,p,spawn,wdisplays")
        (b "screens off" "SUPER+SHIFT,p,${noctalia "dpms-off"}")
      ];
    }
    {
      title = "Screenshots";
      binds = [
        (b "area, annotate in satty" ''SUPER+SHIFT,s,spawn_shell,grim -g "$(slurp)" - | satty --filename - --output-filename ~/Pictures/Screenshots/satty-$(date +%F_%H-%M-%S).png'')
        (b "area to file + clipboard (Print = Fn+K)" "NONE,Print,spawn,${shot}/bin/mango-screenshot area")
        (b "every screen" "SHIFT,Print,spawn,${shot}/bin/mango-screenshot screen")
        (b "focused window" "CTRL,Print,spawn,${shot}/bin/mango-screenshot window")
      ];
    }
    {
      title = "Media (Fn keys work too, also when locked)";
      binds = [
        (l "volume up" "SUPER+ALT,k,${wpctl "set-volume @DEFAULT_AUDIO_SINK@ 5%+"}")
        (l "volume down" "SUPER+ALT,j,${wpctl "set-volume @DEFAULT_AUDIO_SINK@ 5%-"}")
        (l "mute" "SUPER+ALT,m,${wpctl "set-mute @DEFAULT_AUDIO_SINK@ toggle"}")
        (l "play/pause" "SUPER+ALT,space,spawn,playerctl play-pause")
        (l "next track" "SUPER+ALT,l,spawn,playerctl next")
        (l "previous track" "SUPER+ALT,h,spawn,playerctl previous")
        (l "brightness up" "SUPER+ALT,equal,spawn,brightnessctl set 10%+")
        (l "brightness down" "SUPER+ALT,minus,spawn,brightnessctl set 10%-")
        (hl "NONE,XF86AudioRaiseVolume,${wpctl "set-volume @DEFAULT_AUDIO_SINK@ 5%+"}")
        (hl "NONE,XF86AudioLowerVolume,${wpctl "set-volume @DEFAULT_AUDIO_SINK@ 5%-"}")
        (hl "NONE,XF86AudioMute,${wpctl "set-mute @DEFAULT_AUDIO_SINK@ toggle"}")
        (hl "NONE,XF86AudioMicMute,${wpctl "set-mute @DEFAULT_AUDIO_SOURCE@ toggle"}")
        (hl "NONE,XF86MonBrightnessUp,spawn,brightnessctl set 10%+")
        (hl "NONE,XF86MonBrightnessDown,spawn,brightnessctl set 10%-")
        (hl "NONE,XF86AudioPlay,spawn,playerctl play-pause")
        (hl "NONE,XF86AudioNext,spawn,playerctl next")
        (hl "NONE,XF86AudioPrev,spawn,playerctl previous")
      ];
    }
    {
      title = "Session";
      binds = [
        (note "Mod+Shift+/" "this key list")
        (b "reload the config (normally automatic)" "SUPER+SHIFT,c,reload_config")
        (b "quit mango" "SUPER+SHIFT,e,quit")
      ];
    }
    {
      title = "Mouse and touchpad";
      binds = [
        (note "Mod+drag" "move; drop on another window to swap them")
        (note "Mod+right drag" "resize (or drag the gap between two windows)")
        (note "Mod+middle click" "maximize over the tag")
        (note "Mod+Shift+click" "float / tile")
        (note "Mod+Ctrl+right click" "close")
        (note "Mod+scroll" "previous / next tag, empty ones too (sideways: focus left / right)")
        (note "Mod+Shift+scroll" "move the window to the previous / next tag")
        (note "Mod+Ctrl+scroll" "next / previous window")
        (note "Mod+Alt+scroll" "volume")
        (note "Mod+back / forward" "previous / next tag, empty ones too")
        (note "3 fingers" "focus in that direction")
        (note "4 fingers left / right" "next / previous tag")
        (note "4 fingers up / down" "open / close the overview")
        (note "top-left corner" "overview")
      ];
    }
  ];

  entries = lib.concatMap (s: s.binds) sheet;
  linesOf = kind: map (e: e.line) (lib.filter (e: e.kind == kind) entries);

  pad = width: str: str + lib.concatStrings (lib.replicate (lib.max 1 (width - builtins.stringLength str)) " ");
  sheetText =
    lib.concatMapStringsSep "\n\n" (s:
      lib.concatStringsSep "\n" ([s.title]
        ++ map (e: "  ${pad 24 (e.keys or (pretty e.line))}${e.desc}")
        (lib.filter (e: e.desc != null) s.binds)))
    sheet
    + "\n\nLayout menu (Mod+Y, then one key)\n"
    + lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "  ${pad 24 (lib.toUpper k)}${v}") layouts)
    + "\n";

  # Mod+Shift+/: what each bind does (q closes)
  keys = pkgs.writeShellScript "mango-keys" ''
    exec ${pkgs.less}/bin/less -R ${pkgs.writeText "mango-keys.txt" sheetText}
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

  # take the whole tag: master on tile, full width on scroller
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
  # float: mango floats real dialogs itself, these are windows that don't say they are
  float = [
    # small tools that look wrong stretched over a tile
    "^org.gnome.Calculator$"
    "^com.saivert.pwvucontrol$"
    "wdisplays$" # network.cycles.wdisplays
    "^com.gabm.satty$"
    "^com.belmoussaoui.Decoder$" # QR codes
    "^io.gitlab.adhami3310.Impression$" # USB image writer
    "^org.gnome.Snapshot$" # camera
    "^ca.andyholmes.Valent$" # phone (KDE Connect)
    "^(\\.protonvpn-app-wrapped|proton.vpn.app.gtk)$"
    # small games
    "^org.gnome.(Sudoku|Mines|Mahjongg|TwentyFortyEight|Chess)$"
    # password and permission prompts
    "^polkit-.*"
    "^gcr-prompter$" # keyring unlock
    # portal windows (file chooser for flatpaks/browsers, screen share picker)
    "^xdg-desktop-portal.*"
  ];
  # by title, for windows whose app id is empty or shared with the main window
  floatTitle = [
    "^Way-Clicker$" # its app id is empty
    "^Extension: .*" # browser extension popouts (Bitwarden…)
  ];
in {
  home.packages = [
    pkgs.wdisplays # Mod+Ctrl+Shift+P: resolution/refresh/scale by hand (until the next profile switch)
    pkgs.wl-mirror
    displayMode
  ];

  # mango's file watcher misses the symlink swap on a home switch
  xdg.configFile."mango/config.conf".onChange = ''
    for sock in "''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"/mango-*.sock; do
      [ -S "$sock" ] && MANGO_INSTANCE_SIGNATURE="$sock" \
        ${config.wayland.windowManager.mango.package}/bin/mmsg dispatch reload_config >/dev/null || true
    done
  '';

  # outputs, mango only (niri has its own). First matching profile wins, so a new
  # screen starts mirrored; Mod+Ctrl+P cycles mirror/extend/external.
  services.kanshi = {
    enable = true;
    systemdTarget = "mango-session.target";
    settings = let
      laptop = extra:
        {
          criteria = "eDP-1";
          position = "0,0";
          scale = 1.0;
        }
        // extra;
      screen = extra:
        {
          criteria = "*";
          status = "enable";
          scale = 1.0;
        }
        // extra;
      profile = name: outputs: {
        profile = {
          inherit name outputs;
          exec = ["${displayMode}/bin/display-mode applied ${name}"];
        };
      };
    in [
      (profile "laptop" [(laptop {status = "enable";})])
      # far off to the side so the pointer can't wander onto the mirror
      (profile "mirror" [(laptop {status = "enable";}) (screen {position = "10000,0";})])
      (profile "extend" [(laptop {status = "enable";}) (screen {position = "1920,0";})])
      (profile "external" [(laptop {status = "disable";}) (screen {position = "0,0";})])
    ];
  };

  wayland.windowManager.mango = {
    enable = true;
    # mango starts mango-session.target itself; this only defines the unit, which the
    # NixOS module doesn't ship
    systemd.enable = true;

    settings = {
      exec_once = ["noctalia"];
      # QT_QPA_PLATFORM / NIXOS_OZONE_WL: nixos/desktop/niri.nix
      env = ["QT_QPA_PLATFORMTHEME,gtk3"]; # keep in sync with qt.nix

      # --- Look ---
      # default: no blur/shadows/opacity/dimming, outer gaps 10
      border_px = 2;
      no_border_when_single = 1;
      gap_inner_horizontal = 10;
      gap_inner_vertical = 10;
      smart_gaps = 1; # a window alone fills the screen
      # = noctalia's capsule_radius
      border_radius = 10;
      root_color = hex c.bg;
      # also the switcher/overview frames
      focus_color = hex c.orange;
      border_color = hex c.bg3; # bright enough that unfocused windows read as the same size
      urgent_color = hex c.red;
      maximized_screen_color = hex c.yellow;
      scratchpad_color = hex c.blue;
      global_color = hex c.yellow;
      overlay_color = hex c.blue;
      drop_color = "0x${lib.removePrefix "#" c.orange}80"; # where a dragged window will land
      split_color = hex c.orange;
      cursor_theme = "Bibata-Modern-Classic"; # stylix.nix (size 24 is mango's default too)

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
          corner_radius = 10;
          font_desc = "Inter Medium 11";
        };
      };
      group_bar = {
        height = 28;
        decorate = {
          fg_color = hex c.gray;
          bg_color = hex c.bg;
          focus_fg_color = hex c.orange;
          focus_bg_color = hex c.bg1;
          border_color = hex c.bg;
          border_width = 0;
          corner_radius = 10;
          font_desc = "Inter Medium 11";
        };
      };
      title_message_bar.decorate = {
        fg_color = hex c.gray;
        bg_color = hex c.bg;
        focus_fg_color = hex c.fg;
        focus_bg_color = hex c.bg1;
        corner_radius = 10;
        font_desc = "Inter Medium 12";
      };
      jump_label_decorate = {
        fg_color = hex c.fg;
        bg_color = hex c.bg;
        focus_fg_color = hex c.bg;
        focus_bg_color = hex c.orange;
        border_color = hex c.orange;
        border_width = 2;
        corner_radius = 6;
        font_desc = "JetBrainsMono Nerd Font Bold 16";
      };

      # --- Animations: movement only, no fades (no opacity) ---
      # layer animations stay off (default): they glitch on top of noctalia's own
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
      };
      # ease-out-expo for open/move/tag, ease-in for close
      animation_curve = {
        open = "0.16,1,0.3,1";
        move = "0.16,1,0.3,1";
        tag = "0.16,1,0.3,1";
        close = "0.4,0,1,1";
      };

      # --- Input: same as niri-config.nix ---
      xkb_rules_layout = "us";
      xkb_rules_options = "ctrl:nocaps";
      # default: tap to click, drag lock, disable while typing, gestures
      repeat_delay = 500;
      repeat_rate = 50;
      trackpad_natural_scrolling = 1;
      trackpad_accel_speed = 0.9;
      trackpad_scroll_factor = 0.8;
      mouse_accel_speed = 0.5;
      device_rule = ["type:tablet,monitor:eDP-1"];

      # --- Focus and the mouse ---
      # default: focus follows mouse, pointer follows focus, Mod+drag swaps tiles
      cursor_hide_timeout = 5;
      cursor_hide_on_keypress = 1;
      border_resize_size = 8; # grab strip for dragging the edge between two windows: no border to aim at
      enable_floating_snap = 1;
      # top-left corner: overview (like niri's hot corner)
      enable_hotarea = 1;
      hotarea_corner = 0;

      # --- Tags and monitors ---
      view_current_to_back = 1; # Mod+N on the tag you're on goes back (niri back-and-forth)
      focus_cross_monitor = 1; # Mod+H/L walk onto the other monitor at the edge
      exchange_cross_monitor = 1;
      scratchpad_cross_monitor = 1;
      scratchpad_width_ratio = 0.7;
      scratchpad_height_ratio = 0.7;
      special_dim = 0.0; # tag 0 overlay: no dimming (no opacity)
      idle_inhibit_when_fullscreen = 1; # fullscreen video/games keep the screen on
      float_full_to_top = 1; # dialogs open above a fullscreen window (newest on top)
      # no monitor_rule: it would fight kanshi on plug-in
      # lid with an external screen: move to it (and back when opened)
      switchbind = [
        "lid_on,spawn,${displayMode}/bin/display-mode lid-close"
        "lid_off,spawn,${displayMode}/bin/display-mode lid-open"
      ];

      # --- Layouts ---
      # default: tile on every tag, new window = master, 55% master, monocle/deck as tabs
      circle_layout = "tile,dwindle,grid,monocle,deck,scroller";
      monocle_no_border = 1; # one window in view: no border needed
      dwindle_smart_split = 1; # new window goes to the side of the focused one the cursor is on
      dwindle_smart_resize = 1;
      dwindle_preserve_split = 1;
      scroller_structs = 0;
      scroller_default_proportion = 0.5;
      scroller_proportion_preset = "0.333,0.5,0.667,1.0"; # niri's presets
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
        ++ map (t: "is_floating:1,title:${t}") floatTitle
        ++ [
          # archive manager on its own (opening a .zip): a mid-size window, not a full tile
          "is_floating:1,width:0.5,height:0.6,app_id:^org.gnome.FileRoller$"
          # steam's side windows; the main window and games stay tiled
          "is_floating:1,app_id:^steam$,title:^(Friends List|Steam Settings|Special Offers|Screenshot Manager)$"
          # firefox-style library (bookmarks, downloads, history)
          "is_floating:1,app_id:^zen-beta$,title:^Library$"
          # JetBrains IDEs (X11): completion/search popups come as untitled "winN" windows
          "is_floating:1,no_border:1,app_id:^jetbrains-.*,title:^win[0-9]+$"
        ]
        ++ [
          # swallowing (dwm): a GUI app started from a terminal takes the terminal's place
          "is_term:1,app_id:^com.mitchellh.ghostty$"
          "no_swallow:1,app_id:^(zen-beta|firefox|helium)$"
          "is_floating:1,width:0.5,height:0.7,title:^mango-keys$"
          # noctalia's settings window
          "is_floating:1,width:1080,height:920,app_id:^dev.noctalia.Noctalia$"
          # picture-in-picture: small, bottom-right, on every tag, no focus steal
          "is_floating:1,is_global:1,is_open_silent:1,width:480,height:270,offset_x:95,offset_y:90,title:^Picture[ -]in[ -][Pp]icture$"
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
        "shield_when_capture:1,layer_name:^noctalia-notification"
      ];

      # --- Key binds: the lines come from `sheet` above (bind/bindl/bindn) ---
      bind =
        linesOf "bind"
        ++ tags
        # outside `sheet`: the viewer shows the sheet, so it can't be part of it
        ++ ["SUPER+SHIFT,slash,spawn,ghostty --title=mango-keys -e ${keys}"];
      bindl = linesOf "bindl"; # also on the lock screen
      bindn = linesOf "bindn"; # no key repeat

      # --- Mouse ---
      mousebind = [
        "SUPER,btn_left,moveresize,curmove" # drag: float it, or drop it on a tile to swap
        "SUPER,btn_right,moveresize,curresize"
        "SUPER,btn_middle,togglemaximizescreen"
        "SUPER+SHIFT,btn_left,togglefloating"
        "SUPER+CTRL,btn_right,killclient"
        # side buttons with Mod: previous / next tag
        "SUPER,btn_side,viewtoleft,0"
        "SUPER,btn_extra,viewtoright,0"
      ];
      axisbind = [
        "SUPER,UP,viewtoleft,0"
        "SUPER,DOWN,viewtoright,0"
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
