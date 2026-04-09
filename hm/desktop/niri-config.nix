{pkgs, ...}: {
  # home-manager niri config via programs.niri.settings
  # this generates ~/.config/niri/config.kdl
  # all major sections are shown; comment out what you don't need

  programs.niri = {
    enable = true;

    settings = {

      # ------------------------------------------------------------------ #
      # INPUT                                                                #
      # ------------------------------------------------------------------ #
      input = {
        keyboard = {
          xkb = {
            layout = "us";
            # variant = "";
            # model = "";
            options = "ctrl:nocaps"; # caps → ctrl, matching your gnome setting
          };
          repeat-delay = 600;  # ms before key repeat starts
          repeat-rate = 25;    # repeats per second
          # track-layout = "global"; # global | per-window
        };

        touchpad = {
          tap = true;
          # tap-button-map = "left-right-middle"; # left-right-middle | left-middle-right
          natural-scroll = true;
          scroll-factor = 1.0;
          # accel-speed = 0.0;   # -1.0 .. 1.0
          # accel-profile = "adaptive"; # adaptive | flat
          dwt = true;  # disable while typing
          # dwtp = true; # disable while trackpointing
          # click-method = "clickfinger"; # clickfinger | button-areas
        };

        mouse = {
          natural-scroll = false;
          # accel-speed = 0.0;
          # accel-profile = "adaptive"; # adaptive | flat
          # scroll-factor = 1.0;
          # scroll-method = "no-scroll"; # no-scroll | two-finger | edge | on-button-down
          # middle-button-emulation = false;
        };

        # trackpoint = { ... }; # same keys as mouse

        tablet = {
          map-to-output = "eDP-1"; # map pen to a specific output
          # left-handed = false;
        };

        touch = {
          map-to-output = "eDP-1";
        };

        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "0%"; # how far to scroll to focus; 0% = no scroll
        };

        workspace-auto-back-and-forth = false;
        # disabled-monitors = []; # list of output names to ignore for input
      };

      # ------------------------------------------------------------------ #
      # OUTPUTS                                                              #
      # ------------------------------------------------------------------ #
      outputs = {
        # key is the connector name (run `niri msg outputs` to list them)
        "eDP-1" = {
          enable = true;
          # mode = { width = 1920; height = 1080; refresh = 60.0; };
          scale = 1.0;
          # transform = { rotation = 0; flipped = false; };
          position = { x = 0; y = 0; };
          # variable-refresh-rate = false;
        };

        # example second monitor
        # "HDMI-A-1" = {
        #   enable = true;
        #   scale = 1.0;
        #   position = { x = 1920; y = 0; };
        # };
      };

      # ------------------------------------------------------------------ #
      # LAYOUT                                                               #
      # ------------------------------------------------------------------ #
      layout = {
        # gap between windows and to screen edges
        gaps = 8;

        # struts shrink the area niri considers usable (useful for bars)
        struts = {
          left = 0;
          right = 0;
          top = 0;
          bottom = 0;
        };

        # default column width when a window first opens
        default-column-width = {}; # {} = auto; or { proportion = 0.5; } or { fixed = 800; }

        center-focused-column = "never"; # never | always | on-overflow

        preset-column-widths = [
          { proportion = 0.333; }
          { proportion = 0.5; }
          { proportion = 0.667; }
          { proportion = 1.0; }
        ];

        preset-window-heights = [
          { proportion = 0.333; }
          { proportion = 0.5; }
          { proportion = 0.667; }
          { proportion = 1.0; }
        ];

        focus-ring = {
          enable = true;
          width = 2;
          active = {
            color = "#7fc8ff";
            # gradient = { from = "#.."; to = "#.."; angle = 45; relative-to = "workspace-view"; };
          };
          inactive = {
            color = "#404040";
          };
        };

        border = {
          enable = false; # border draws outside; focus-ring draws inside
          width = 2;
          active.color = "#7fc8ff";
          inactive.color = "#404040";
        };

        shadow = {
          enable = false;
          # softness = 30;
          # spread = 5;
          # offset = { x = 0; y = 5; };
          # color = "#00000070";
        };

        tab-indicator = {
          # shown when a column has multiple windows stacked
          enable = true;
          # position = "left"; # left | right | top | bottom
          # gap = 4;
          # width = 4;
          # length.total-proportion = 0.1;
          # place-within-column = false;
          # active.color = "#7fc8ff";
          # inactive.color = "#404040";
          # urgent.color = "#ff5f57";
        };

        # insert-hint shown when dragging a window to a new position
        insert-hint = {
          # enable = true;
          # color = "#7fc8ff80";
          # gradient = { ... };
        };
      };

      # ------------------------------------------------------------------ #
      # WORKSPACES (named)                                                   #
      # ------------------------------------------------------------------ #
      workspaces = {
        "1" = {};
        "2" = {};
        "3" = {};
        "4" = {};
      };

      # ------------------------------------------------------------------ #
      # CURSOR                                                               #
      # ------------------------------------------------------------------ #
      cursor = {
        theme = "Adwaita";
        size = 24;
        # hide-when-typing = false;
        # hide-after-inactive-ms = null;
      };

      # ------------------------------------------------------------------ #
      # WINDOW RULES                                                         #
      # ------------------------------------------------------------------ #
      window-rules = [
        # match on app-id (wayland) or title
        # {
        #   matches = [{ app-id = "firefox"; }];
        #   default-column-width = { proportion = 0.667; };
        #   open-on-workspace = "2";
        #   open-maximized = false;
        #   open-fullscreen = false;
        #   open-floating = false;
        #   focus-ring.active.color = "#ff9e64";
        # }

        # floating dialogs
        {
          matches = [
            { is-dialog = true; }
            { app-id = "^(xdg-desktop-portal|polkit)"; }
          ];
          open-floating = true;
        }

        # fix screensharing: mark niri's own windows as opaque
        {
          matches = [{}]; # matches all
          clip-to-display-region = true;
          geometry-corner-radius = {
            top-left = 8.0;
            top-right = 8.0;
            bottom-left = 8.0;
            bottom-right = 8.0;
          };
        }
      ];

      # ------------------------------------------------------------------ #
      # LAYER RULES (for bars, notifications, etc.)                         #
      # ------------------------------------------------------------------ #
      layer-rules = [
        # {
        #   matches = [{ namespace = "waybar"; }];
        #   shadow.enable = true;
        # }
      ];

      # ------------------------------------------------------------------ #
      # ANIMATIONS                                                           #
      # ------------------------------------------------------------------ #
      animations = {
        enable = true;
        # slowdown = 1.0; # global multiplier; >1 = slower, useful for debugging

        workspace-switch = {
          spring = { damping-ratio = 1.0; stiffness = 1000; epsilon = 0.0001; };
        };

        window-open = {
          duration-ms = 150;
          curve = "ease-out-expo";
        };

        window-close = {
          duration-ms = 150;
          curve = "ease-out-quad";
        };

        horizontal-view-movement = {
          spring = { damping-ratio = 1.0; stiffness = 800; epsilon = 0.0001; };
        };

        window-movement = {
          spring = { damping-ratio = 1.0; stiffness = 800; epsilon = 0.0001; };
        };

        window-resize = {
          spring = { damping-ratio = 1.0; stiffness = 800; epsilon = 0.0001; };
        };

        config-notification-open-close = {
          spring = { damping-ratio = 0.6; stiffness = 1000; epsilon = 0.001; };
        };

        screenshot-ui-open = {
          duration-ms = 200;
          curve = "ease-out-quad";
        };
      };

      # ------------------------------------------------------------------ #
      # SCREENSHOT UI                                                        #
      # ------------------------------------------------------------------ #
      screenshot-path = "~/Pictures/Screenshots/Screenshot %Y-%m-%d %H-%M-%S.png";
      # set to null to copy to clipboard only

      # ------------------------------------------------------------------ #
      # KEY BINDINGS                                                         #
      # ------------------------------------------------------------------ #
      binds = with pkgs.lib.niri; let
        # terminal / launcher
        term = "ghostty";
        browser = "zen-beta";
        launcher = "fuzzel"; # or wofi, rofi-wayland, etc.
        files = "nautilus";
      in {

        # -- session --
        "Mod+Shift+E".action = quit {};
        "Mod+Shift+P".action = power-off-monitors {};

        # -- apps --
        "Mod+Return".action    = spawn term;
        "Mod+W".action         = spawn browser;
        "Mod+E".action         = spawn files;
        "Mod+Space".action     = spawn launcher;
        "Mod+Shift+Return".action = spawn [term "-e" "nvim"];
        "Ctrl+Shift+Escape".action = spawn "missioncenter";

        # screenshot
        "Print".action            = screenshot;
        "Shift+Print".action      = screenshot-screen;
        "Ctrl+Print".action       = screenshot-window;

        # -- focus --
        "Mod+H".action = focus-column-left {};
        "Mod+L".action = focus-column-right {};
        "Mod+J".action = focus-window-down {};
        "Mod+K".action = focus-window-up {};

        "Mod+Left".action  = focus-column-left {};
        "Mod+Right".action = focus-column-right {};
        "Mod+Down".action  = focus-window-down {};
        "Mod+Up".action    = focus-window-up {};

        # focus first/last column
        "Mod+Home".action = focus-column-first {};
        "Mod+End".action  = focus-column-last {};

        # -- move windows --
        "Mod+Shift+H".action = move-column-left {};
        "Mod+Shift+L".action = move-column-right {};
        "Mod+Shift+J".action = move-window-down {};
        "Mod+Shift+K".action = move-window-up {};

        "Mod+Shift+Left".action  = move-column-left {};
        "Mod+Shift+Right".action = move-column-right {};
        "Mod+Shift+Down".action  = move-window-down {};
        "Mod+Shift+Up".action    = move-window-up {};

        "Mod+Shift+Home".action = move-column-to-first {};
        "Mod+Shift+End".action  = move-column-to-last {};

        # -- workspaces --
        "Mod+1".action = focus-workspace 1;
        "Mod+2".action = focus-workspace 2;
        "Mod+3".action = focus-workspace 3;
        "Mod+4".action = focus-workspace 4;

        "Mod+Shift+1".action = move-column-to-workspace 1;
        "Mod+Shift+2".action = move-column-to-workspace 2;
        "Mod+Shift+3".action = move-column-to-workspace 3;
        "Mod+Shift+4".action = move-column-to-workspace 4;

        "Mod+BracketLeft".action  = focus-workspace-down {};
        "Mod+BracketRight".action = focus-workspace-up {};
        "Mod+Shift+BracketLeft".action  = move-column-to-workspace-down {};
        "Mod+Shift+BracketRight".action = move-column-to-workspace-up {};

        # -- sizing --
        "Mod+Minus".action      = set-column-width "-10%";
        "Mod+Equal".action      = set-column-width "+10%";
        "Mod+Shift+Minus".action = set-window-height "-10%";
        "Mod+Shift+Equal".action = set-window-height "+10%";

        "Mod+R".action = switch-preset-column-width {};
        "Mod+Shift+R".action = switch-preset-window-height {};
        "Mod+F".action = maximize-column {};
        "Mod+Shift+F".action = fullscreen-window {};
        "Mod+C".action = center-column {};

        # consume / expel (stack windows in a column)
        "Mod+Comma".action  = consume-window-into-column {};
        "Mod+Period".action = expel-window-from-column {};

        # -- window management --
        "Mod+Q".action       = close-window {};
        "Mod+T".action       = toggle-window-floating {};
        "Mod+Shift+T".action = toggle-column-tabbed-display {};

        # move window between monitors
        # "Mod+Shift+W".action = move-column-to-monitor-left {};

        # -- media keys --
        "XF86AudioRaiseVolume".action  = spawn ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"];
        "XF86AudioLowerVolume".action  = spawn ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"];
        "XF86AudioMute".action         = spawn ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
        "XF86AudioMicMute".action      = spawn ["wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];
        "XF86MonBrightnessUp".action   = spawn ["brightnessctl" "set" "10%+"];
        "XF86MonBrightnessDown".action = spawn ["brightnessctl" "set" "10%-"];
        "XF86AudioPlay".action  = spawn ["playerctl" "play-pause"];
        "XF86AudioNext".action  = spawn ["playerctl" "next"];
        "XF86AudioPrev".action  = spawn ["playerctl" "previous"];

        # -- scroll the view (niri's horizontal canvas) --
        "Mod+WheelScrollRight".action       = focus-column-right {};
        "Mod+WheelScrollLeft".action        = focus-column-left {};
        "Mod+Shift+WheelScrollRight".action = move-column-right {};
        "Mod+Shift+WheelScrollLeft".action  = move-column-left {};
        "Mod+WheelScrollDown".action        = focus-workspace-down {};
        "Mod+WheelScrollUp".action          = focus-workspace-up {};
      };

      # ------------------------------------------------------------------ #
      # STARTUP PROGRAMS                                                     #
      # ------------------------------------------------------------------ #
      spawn-at-startup = [
        { command = ["waybar"]; }
        { command = ["dunst"]; }        # notification daemon
        { command = ["cliphist" "store"]; }  # clipboard history; pipe from wl-paste
        { command = ["nm-applet" "--indicator"]; }
        # { command = ["swww-daemon"]; }  # wallpaper daemon
        # { command = ["udiskie"]; }      # automount
      ];

      # ------------------------------------------------------------------ #
      # MISCELLANEOUS                                                        #
      # ------------------------------------------------------------------ #
      prefer-no-csd = true; # ask apps to use server-side decorations

      # hotkey-overlay shown on first launch
      hotkey-overlay.skip-at-startup = false;

      # environment variables injected into the niri environment
      # (picked up by all child processes)
      environment = {
        DISPLAY = ":0"; # set by XWayland automatically; listed for visibility
        QT_QPA_PLATFORM = "wayland;xcb";
        NIXOS_OZONE_WL = "1";
      };
    };
  };
}
