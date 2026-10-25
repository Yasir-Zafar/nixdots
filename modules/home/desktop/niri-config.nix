# niri (26.04) via niri-flake. Docs: https://niri-wm.github.io/niri and niri-flake's docs.md.
# Look (docs/PREFERENCES.md): no gaps, no focus ring, no border, no shadows, square corners.
# Noctalia's own niri recommendations (layer rules, debug flag) come from its
# docs/user/compositor-settings/niri.mdx.
let
  # gruvbox dark medium
  c = {
    bg2 = "#504945";
    red = "#fb4934";
    orange = "#fe8019";
  };

  spring = stiffness: {
    spring = {
      damping-ratio = 1.0;
      inherit stiffness;
      epsilon = 0.0001;
    };
  };
  easing = duration-ms: curve: {easing = {inherit duration-ms curve;};};

  # spawn bind with a hotkey-overlay title (every spawn bind gets one, so Mod+Shift+/ reads well)
  run = title: argv: {
    action.spawn = argv;
    hotkey-overlay.title = title;
  };
  noctalia = title: args: run title (["noctalia" "msg"] ++ args);
  # media keys: also on the lock screen
  key = title: argv: run title argv // {allow-when-locked = true;};
in {
  programs.niri = {
    enable = true;

    settings = {
      input = {
        keyboard = {
          xkb = {
            layout = "us";
            options = "ctrl:nocaps";
          };
          repeat-delay = 500;
          repeat-rate = 50;
        };

        touchpad = {
          tap = true;
          natural-scroll = true;
          scroll-factor = 0.8;
          accel-speed = 0.9;
          dwt = true;
        };

        mouse = {
          natural-scroll = false;
          accel-speed = 0.5;
          scroll-factor = 1.0;
        };

        tablet.map-to-output = "eDP-1";

        # Mod+N on the workspace you're already on goes back to the previous one
        workspace-auto-back-and-forth = true;
        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "20%";
        };
        # keyboard focus changes move the pointer along, so it never sits over another window
        warp-mouse-to-focus.enable = true;
      };

      # theme and size stay at niri-flake's "default"/24: ~/.icons/default inherits Bibata (stylix)
      cursor = {
        # niri warns this can break mouselook in some Wine games; set false if one misbehaves
        hide-when-typing = true;
        hide-after-inactive-ms = 5000;
      };

      outputs = {
        # the panel has no VRR (`niri msg outputs`), so no variable-refresh-rate here
        "eDP-1" = {
          scale = 1.0;
          position = {
            x = 0;
            y = 0;
          };
          focus-at-startup = true;
        };
        "HDMI-A-1" = {
          scale = 1.0;
          position = {
            x = 1920;
            y = 0;
          };
        };
      };

      layout = {
        gaps = 0;
        center-focused-column = "on-overflow";
        always-center-single-column = true;
        # empty: the window picks its own width
        default-column-width = {};

        preset-column-widths = map (p: {proportion = p;}) [0.333 0.5 0.667 1.0];
        preset-window-heights = map (p: {proportion = p;}) [0.333 0.5 0.667 1.0];

        focus-ring.enable = false;
        border.enable = false;
        shadow.enable = false;

        # tabbed columns (Mod+Shift+T): a thin bar inside the column, only with 2+ tabs
        tab-indicator = {
          enable = true;
          place-within-column = true;
          hide-when-single-tab = true;
          position = "left";
          width = 3;
          gap = 0;
          gaps-between-tabs = 2;
          active.color = c.orange;
          inactive.color = c.bg2;
          urgent.color = c.red;
        };

        # where a dragged window will land
        insert-hint.display.color = "${c.orange}80";

        # transparent workspaces: the wallpaper lives in the backdrop (layer rule below), so it
        # stays put while workspaces scroll and shows behind the overview
        background-color = "transparent";
      };

      overview = {
        zoom = 0.5;
        workspace-shadow.enable = false;
      };

      # niri's own Alt-Tab (MRU with previews). Alt+Tab itself stays noctalia's switcher
      # (normal binds win), so this only adds switching between windows of the same app
      recent-windows = {
        highlight = {
          active-color = c.orange;
          urgent-color = c.red;
          corner-radius = 0;
        };
        binds = {
          "Alt+grave".action.next-window = {filter = "app-id";};
          "Alt+Shift+grave".action.previous-window = {filter = "app-id";};
          "Mod+grave".action.next-window = {filter = "app-id";};
          "Mod+Shift+grave".action.previous-window = {filter = "app-id";};
        };
      };

      # top-left corner toggles the overview, also while dragging something
      gestures.hot-corners.enable = true;

      window-rules = [
        # square corners, contents clipped to them
        {
          matches = [{}];
          clip-to-geometry = true;
          geometry-corner-radius = {
            top-left = 0.0;
            top-right = 0.0;
            bottom-left = 0.0;
            bottom-right = 0.0;
          };
        }

        # portals and dialogs take focus so niri scrolls to them; they tile at their own width
        {
          matches = [
            {app-id = "^(xdg-desktop-portal.*|polkit-.*)";}
            {title = "^(Open|Save|Choose|Select|Browse).*";}
          ];
          open-focused = true;
          default-column-width = {};
        }

        # full width for the main apps
        {
          matches = [
            {app-id = "^zen-beta$";}
            {app-id = "^firefox$";}
            {app-id = "^com.mitchellh.ghostty";}
            {app-id = "^emacs";}
          ];
          open-maximized = true;
        }

        # small utilities float instead of taking a column
        {
          matches = [
            {app-id = "^org.gnome.Calculator$";}
            {app-id = "^org.pulseaudio.pavucontrol$";}
          ];
          open-floating = true;
        }

        # noctalia's settings window
        {
          matches = [{app-id = "^dev.noctalia.Noctalia$";}];
          open-floating = true;
          default-column-width.fixed = 1080;
          default-window-height.fixed = 920;
        }

        # picture-in-picture: floating in the bottom-right corner, without stealing focus
        {
          matches = [
            {
              app-id = "^zen-beta$";
              title = "^Picture-in-Picture$";
            }
          ];
          open-floating = true;
          open-focused = false;
          default-floating-position = {
            x = 16;
            y = 16;
            relative-to = "bottom-right";
          };
        }

        # steam toasts: floating, bottom-right, never stealing focus from the game
        {
          matches = [
            {
              app-id = "^steam$";
              title = "^notificationtoasts_[0-9]+_desktop$";
            }
          ];
          open-floating = true;
          open-focused = false;
          default-floating-position = {
            x = 10;
            y = 10;
            relative-to = "bottom-right";
          };
        }
      ];

      layer-rules = [
        # the wallpaper sits in the backdrop (see layout.background-color)
        {
          matches = [{namespace = "^noctalia-wallpaper";}];
          place-within-backdrop = true;
        }
        # no blur. Noctalia asks niri to blur behind its surfaces by itself
        # (ext-background-effect), so it has to be switched off here
        {
          matches = [{namespace = "^noctalia-";}];
          background-effect.blur = false;
        }
        # notifications stay out of screen shares and recordings
        {
          matches = [{namespace = "^noctalia-notification";}];
          block-out-from = "screencast";
        }
      ];

      animations = {
        workspace-switch.kind = spring 1000;
        horizontal-view-movement.kind = spring 800;
        window-movement.kind = spring 800;
        window-resize.kind = spring 800;
        overview-open-close.kind = spring 800;
        config-notification-open-close.kind.spring = {
          damping-ratio = 0.6;
          stiffness = 1000;
          epsilon = 0.001;
        };
        window-open.kind = easing 150 "ease-out-expo";
        window-close.kind = easing 150 "ease-out-quad";
        screenshot-ui-open.kind = easing 200 "ease-out-quad";
      };

      screenshot-path = "~/Pictures/Screenshots/Screenshot %Y-%m-%d %H-%M-%S.png";

      binds = {
        # --- Session ---
        "Mod+Shift+E".action.quit = {};
        "Mod+Shift+P".action.power-off-monitors = {};
        "Mod+Shift+Slash".action.show-hotkey-overlay = {};
        # let a VM or remote desktop have Mod+… keys; this bind itself can't be inhibited
        "Mod+Ctrl+Escape" = {
          action.toggle-keyboard-shortcuts-inhibit = {};
          allow-inhibiting = false;
        };

        # --- Applications ---
        "Mod+Return" = run "Terminal" ["ghostty"];
        "Mod+Shift+Return" = run "Neovim" ["ghostty" "-e" "nvim"];
        "Mod+W" = run "Zen" ["zen-beta"];
        "Mod+E" = run "Files" ["nautilus"];
        "Mod+Shift+U" = run "nx: updates and system overview (TUI)" ["ghostty" "--title=nx" "-e" "nx" "tui"];
        "Ctrl+Shift+Escape" = run "Mission Center" ["missioncenter"];
        "Mod+X" = run "Autoclicker: start/stop" ["way-clicker" "--nogui" "--toggle"];

        # --- Noctalia (`noctalia msg --help`) ---
        "Mod+Space" = noctalia "Launcher" ["panel-toggle" "launcher"];
        "Mod+P" = noctalia "Launcher" ["panel-toggle" "launcher"];
        "Mod+Semicolon" = noctalia "Emoji picker" ["panel-toggle" "launcher" "/emo"];
        "Mod+V" = noctalia "Clipboard history" ["panel-toggle" "clipboard"];
        "Mod+A" = noctalia "Control center" ["panel-toggle" "control-center"];
        "Mod+Escape" = noctalia "Session menu" ["panel-toggle" "session"];
        "Mod+Shift+Escape" = noctalia "Lock screen" ["session" "lock"];
        "Mod+B" = noctalia "Cycle power profile" ["power-cycle"];
        "Mod+I" = noctalia "Toggle caffeine (no sleep)" ["caffeine-toggle"];
        "Mod+Shift+N" = noctalia "Toggle do-not-disturb" ["notification-dnd-toggle"];
        "Mod+Shift+B" = noctalia "Toggle bar" ["bar-toggle"];
        # hold: a quick tap switches straight to the previous window
        "Alt+Tab" = noctalia "Window switcher" ["window-switcher" "hold"];
        "Mod+Tab" = {
          action.toggle-overview = {};
          repeat = false;
        };

        # --- Screenshots ---
        "Print".action.screenshot = {};
        "Shift+Print".action.screenshot-screen = {};
        "Ctrl+Print".action.screenshot-window = {};
        # select an area and annotate it (arrows, text, blur), then save or copy
        "Mod+Shift+S" = {
          action.spawn-sh = ''grim -g "$(slurp)" - | satty --filename - --output-filename ~/Pictures/Screenshots/satty-$(date +%F_%H-%M-%S).png'';
          hotkey-overlay.title = "Screenshot an area and annotate it";
        };

        # --- Screencast: share one window/monitor and switch it on the fly ---
        # (pick "niri dynamic cast target" in the portal dialog)
        "Mod+Ctrl+S".action.set-dynamic-cast-window = {};
        "Mod+Ctrl+Shift+S".action.clear-dynamic-cast-target = {};

        # --- Monitors (laptop + HDMI): Ctrl = monitor, Ctrl+Shift = take the column there ---
        "Mod+Ctrl+H".action.focus-monitor-left = {};
        "Mod+Ctrl+L".action.focus-monitor-right = {};
        "Mod+Ctrl+Left".action.focus-monitor-left = {};
        "Mod+Ctrl+Right".action.focus-monitor-right = {};
        "Mod+Ctrl+Shift+H".action.move-column-to-monitor-left = {};
        "Mod+Ctrl+Shift+L".action.move-column-to-monitor-right = {};
        "Mod+Ctrl+Shift+Left".action.move-column-to-monitor-left = {};
        "Mod+Ctrl+Shift+Right".action.move-column-to-monitor-right = {};

        # --- Focus (vim keys + arrows) ---
        "Mod+H".action.focus-column-left = {};
        "Mod+L".action.focus-column-right = {};
        "Mod+J".action.focus-window-down = {};
        "Mod+K".action.focus-window-up = {};
        "Mod+Left".action.focus-column-left = {};
        "Mod+Right".action.focus-column-right = {};
        "Mod+Down".action.focus-window-down = {};
        "Mod+Up".action.focus-window-up = {};
        "Mod+Home".action.focus-column-first = {};
        "Mod+End".action.focus-column-last = {};

        # --- Move ---
        "Mod+Shift+H".action.move-column-left = {};
        "Mod+Shift+L".action.move-column-right = {};
        "Mod+Shift+J".action.move-window-down = {};
        "Mod+Shift+K".action.move-window-up = {};
        "Mod+Shift+Left".action.move-column-left = {};
        "Mod+Shift+Right".action.move-column-right = {};
        "Mod+Shift+Down".action.move-window-down = {};
        "Mod+Shift+Up".action.move-window-up = {};
        "Mod+Shift+Home".action.move-column-to-first = {};
        "Mod+Shift+End".action.move-column-to-last = {};

        # --- Workspaces ---
        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+Shift+1".action.move-column-to-workspace = 1;
        "Mod+Shift+2".action.move-column-to-workspace = 2;
        "Mod+Shift+3".action.move-column-to-workspace = 3;
        "Mod+Shift+4".action.move-column-to-workspace = 4;
        "Mod+Shift+5".action.move-column-to-workspace = 5;
        "Mod+BracketLeft".action.focus-workspace-down = {};
        "Mod+BracketRight".action.focus-workspace-up = {};
        "Mod+Shift+BracketLeft".action.move-column-to-workspace-down = {};
        "Mod+Shift+BracketRight".action.move-column-to-workspace-up = {};

        # --- Size ---
        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";
        "Mod+R".action.switch-preset-column-width = {};
        "Mod+Shift+R".action.switch-preset-window-height = {};
        "Mod+Ctrl+R".action.reset-window-height = {};
        "Mod+F".action.maximize-column = {};
        "Mod+Ctrl+F".action.expand-column-to-available-width = {};
        "Mod+Shift+F".action.fullscreen-window = {};
        # tells the app it is maximized (no gaps here, so it mostly matters for the app's own UI)
        "Mod+M".action.maximize-window-to-edges = {};
        "Mod+C".action.center-column = {};
        "Mod+Ctrl+C".action.center-visible-columns = {};

        # --- Columns and windows ---
        "Mod+Comma".action.consume-window-into-column = {};
        "Mod+Period".action.expel-window-from-column = {};
        "Mod+Q" = {
          action.close-window = {};
          repeat = false;
        };
        "Mod+T".action.toggle-window-floating = {};
        # without this a floating window (PiP, dialogs) can't be refocused from the keyboard
        "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = {};
        "Mod+Shift+T".action.toggle-column-tabbed-display = {};

        # --- Media keys ---
        "XF86AudioRaiseVolume" = key "Volume up" ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"];
        "XF86AudioLowerVolume" = key "Volume down" ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"];
        "XF86AudioMute" = key "Mute" ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
        "XF86AudioMicMute" = key "Mute microphone" ["wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];
        "XF86MonBrightnessUp" = key "Brightness up" ["brightnessctl" "set" "10%+"];
        "XF86MonBrightnessDown" = key "Brightness down" ["brightnessctl" "set" "10%-"];
        "XF86AudioPlay" = key "Play/pause" ["playerctl" "play-pause"];
        "XF86AudioNext" = key "Next track" ["playerctl" "next"];
        "XF86AudioPrev" = key "Previous track" ["playerctl" "previous"];

        # --- Mouse wheel ---
        "Mod+WheelScrollRight".action.focus-column-right = {};
        "Mod+WheelScrollLeft".action.focus-column-left = {};
        "Mod+Shift+WheelScrollRight".action.move-column-right = {};
        "Mod+Shift+WheelScrollLeft".action.move-column-left = {};
        # cooldown: a touchpad scroll is a burst of events and would run through every workspace
        "Mod+WheelScrollDown" = {
          action.focus-workspace-down = {};
          cooldown-ms = 150;
        };
        "Mod+WheelScrollUp" = {
          action.focus-workspace-up = {};
          cooldown-ms = 150;
        };
        "Mod+Shift+WheelScrollDown" = {
          action.move-column-to-workspace-down = {};
          cooldown-ms = 150;
        };
        "Mod+Shift+WheelScrollUp" = {
          action.move-column-to-workspace-up = {};
          cooldown-ms = 150;
        };
      };

      spawn-at-startup = [{argv = ["noctalia"];}];

      prefer-no-csd = true;
      hotkey-overlay = {
        skip-at-startup = true;
        hide-not-bound = true;
      };
      xwayland-satellite.enable = true;

      # QT_QPA_PLATFORM / NIXOS_OZONE_WL come from modules/nixos/desktop/niri.nix (session-wide)
      environment.QT_QPA_PLATFORMTHEME = "gtk3"; # keep in sync with qt.nix

      debug = {
        # noctalia: lets notification actions focus the app that sent them
        honor-xdg-activation-with-invalid-serial = [];
      };
    };
  };
}
