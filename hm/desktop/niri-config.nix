{pkgs, ...}: {
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
            options = "ctrl:nocaps";
          };
          repeat-delay = 600;
          repeat-rate = 25;
          # track-layout = "global"; # global | per-window
        };

        touchpad = {
          tap = true;
          # tap-button-map = "left-right-middle";
          natural-scroll = true;
          scroll-factor = 1.0;
          # accel-speed = 0.0;
          # accel-profile = "adaptive";
          dwt = true;
          # dwtp = true;
          # click-method = "clickfinger";
        };

        mouse = {
          natural-scroll = false;
          # accel-speed = 0.0;
          # accel-profile = "adaptive";
          # scroll-factor = 1.0;
          # scroll-method = "no-scroll";
          # middle-button-emulation = false;
        };

        # trackpoint = { ... };

        tablet = {
          map-to-output = "eDP-1";
          # left-handed = false;
        };

        touch = {
          map-to-output = "eDP-1";
        };

        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "0%";
        };

        workspace-auto-back-and-forth = false;
      };

      # ------------------------------------------------------------------ #
      # OUTPUTS                                                              #
      # ------------------------------------------------------------------ #
      outputs = {
        "eDP-1" = {
          enable = true;
          # mode = { width = 1920; height = 1080; refresh = 60.0; };
          scale = 1.0;
          # transform = { rotation = 0; flipped = false; };
          position = {
            x = 0;
            y = 0;
          };
          # variable-refresh-rate = false;
        };

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
        gaps = 8;

        struts = {
          left = 0;
          right = 0;
          top = 0;
          bottom = 0;
        };

        default-column-width = {};

        center-focused-column = "never";

        preset-column-widths = [
          {proportion = 0.333;}
          {proportion = 0.5;}
          {proportion = 0.667;}
          {proportion = 1.0;}
        ];

        preset-window-heights = [
          {proportion = 0.333;}
          {proportion = 0.5;}
          {proportion = 0.667;}
          {proportion = 1.0;}
        ];

        focus-ring = {
          enable = true;
          width = 2;
          active.color = "#7fc8ff";
          inactive.color = "#404040";
        };

        border = {
          enable = false;
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
          enable = true;
          # position = "left";
          # gap = 4;
          # width = 4;
          # active.color = "#7fc8ff";
          # inactive.color = "#404040";
        };

        # insert-hint takes color/gradient, not enable
        # insert-hint.color = "#7fc8ff80";
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
        # floating dialogs — is-dialog is niri-unstable only;
        # use app-id regex for stable
        # {
        #   matches = [{ app-id = "^(xdg-desktop-portal|polkit)"; }];
        #   open-floating = true;
        # }

        # rounded corners + clip for all windows
        {
          matches = [{}];
          clip-to-geometry = true; # was clip-to-display-region (doesn't exist)
          geometry-corner-radius = {
            top-left = 8.0;
            top-right = 8.0;
            bottom-left = 8.0;
            bottom-right = 8.0;
          };
        }
      ];

      # ------------------------------------------------------------------ #
      # LAYER RULES                                                          #
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
        # slowdown = 1.0;

        workspace-switch.spring = {
          damping-ratio = 1.0;
          stiffness = 1000;
          epsilon = 0.0001;
        };

        window-open = {
          duration-ms = 150;
          curve = "ease-out-expo";
        };

        window-close = {
          duration-ms = 150;
          curve = "ease-out-quad";
        };

        horizontal-view-movement.spring = {
          damping-ratio = 1.0;
          stiffness = 800;
          epsilon = 0.0001;
        };

        window-movement.spring = {
          damping-ratio = 1.0;
          stiffness = 800;
          epsilon = 0.0001;
        };

        window-resize.spring = {
          damping-ratio = 1.0;
          stiffness = 800;
          epsilon = 0.0001;
        };

        config-notification-open-close.spring = {
          damping-ratio = 0.6;
          stiffness = 1000;
          epsilon = 0.001;
        };

        screenshot-ui-open = {
          duration-ms = 200;
          curve = "ease-out-quad";
        };
      };

      # ------------------------------------------------------------------ #
      # SCREENSHOT                                                           #
      # ------------------------------------------------------------------ #
      screenshot-path = "~/Pictures/Screenshots/Screenshot %Y-%m-%d %H-%M-%S.png";

      # ------------------------------------------------------------------ #
      # KEY BINDINGS                                                         #
      # ------------------------------------------------------------------ #
      binds = {
        # -- session --
        "Mod+Shift+E".action.quit = {};
        "Mod+Shift+P".action.power-off-monitors = {};

        # -- apps --
        "Mod+Return".action.spawn = ["ghostty"];
        "Mod+W".action.spawn = ["zen-beta"];
        "Mod+E".action.spawn = ["nautilus"];
        "Mod+Space".action.spawn = ["fuzzel"];
        "Mod+Shift+Return".action.spawn = ["ghostty" "-e" "nvim"];
        "Ctrl+Shift+Escape".action.spawn = ["missioncenter"];

        # -- screenshots --
        "Print".action.screenshot = {};
        "Shift+Print".action.screenshot-screen = {};
        "Ctrl+Print".action.screenshot-window = {};

        # -- focus --
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

        # -- move --
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

        # -- workspaces --
        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;

        "Mod+Shift+1".action.move-column-to-workspace = 1;
        "Mod+Shift+2".action.move-column-to-workspace = 2;
        "Mod+Shift+3".action.move-column-to-workspace = 3;
        "Mod+Shift+4".action.move-column-to-workspace = 4;

        "Mod+BracketLeft".action.focus-workspace-down = {};
        "Mod+BracketRight".action.focus-workspace-up = {};
        "Mod+Shift+BracketLeft".action.move-column-to-workspace-down = {};
        "Mod+Shift+BracketRight".action.move-column-to-workspace-up = {};

        # -- sizing --
        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";

        "Mod+R".action.switch-preset-column-width = {};
        "Mod+Shift+R".action.switch-preset-window-height = {};
        "Mod+F".action.maximize-column = {};
        "Mod+Shift+F".action.fullscreen-window = {};
        "Mod+C".action.center-column = {};

        # consume / expel (stack windows in a column)
        "Mod+Comma".action.consume-window-into-column = {};
        "Mod+Period".action.expel-window-from-column = {};

        # -- window management --
        "Mod+Q".action.close-window = {};
        # toggle-window-floating and toggle-column-tabbed-display
        # are niri-unstable only; remove if using niri-stable
        "Mod+T".action.toggle-window-floating = {};
        "Mod+Shift+T".action.toggle-column-tabbed-display = {};

        # -- media keys --
        "XF86AudioRaiseVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"];
        "XF86AudioLowerVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"];
        "XF86AudioMute".action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
        "XF86AudioMicMute".action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];
        "XF86MonBrightnessUp".action.spawn = ["brightnessctl" "set" "10%+"];
        "XF86MonBrightnessDown".action.spawn = ["brightnessctl" "set" "10%-"];
        "XF86AudioPlay".action.spawn = ["playerctl" "play-pause"];
        "XF86AudioNext".action.spawn = ["playerctl" "next"];
        "XF86AudioPrev".action.spawn = ["playerctl" "previous"];

        # -- scroll canvas --
        "Mod+WheelScrollRight".action.focus-column-right = {};
        "Mod+WheelScrollLeft".action.focus-column-left = {};
        "Mod+Shift+WheelScrollRight".action.move-column-right = {};
        "Mod+Shift+WheelScrollLeft".action.move-column-left = {};
        "Mod+WheelScrollDown".action.focus-workspace-down = {};
        "Mod+WheelScrollUp".action.focus-workspace-up = {};
      };

      # ------------------------------------------------------------------ #
      # STARTUP                                                              #
      # ------------------------------------------------------------------ #
      spawn-at-startup = [
        {command = ["fuzzel"];}
        {command = ["noctal"];}
        {command = ["sh" "-c" "wl-paste --watch cliphist store"];}
        # { command = [ "swww-daemon" ]; }
      ];

      # ------------------------------------------------------------------ #
      # MISC                                                                 #
      # ------------------------------------------------------------------ #
      prefer-no-csd = true;

      hotkey-overlay.skip-at-startup = false;

      environment = {
        # DISPLAY is set automatically by xwayland-satellite — do not set it here
        QT_QPA_PLATFORM = "wayland;xcb";
        NIXOS_OZONE_WL = "1";
      };
    };
  };
}
