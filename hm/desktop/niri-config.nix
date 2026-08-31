{
  programs.niri = {
    enable = true;

    settings = {
      # --- Input ---
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
          # accel-profile = "adaptive";
          # dwtp = true;
          # click-method = "clickfinger";
        };

        mouse = {
          natural-scroll = false;
          accel-speed = 0.5;
          scroll-factor = 1.0;
        };

        tablet.map-to-output = "eDP-1";
        workspace-auto-back-and-forth = true;

        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "20%";
        };
      };

      # --- Outputs ---
      outputs = {
        "eDP-1" = {
          enable = true;
          scale = 1.0;
          variable-refresh-rate = "on-demand";
          position = {
            x = 0;
            y = 0;
          };
          # mode = { width = 1920; height = 1080; refresh = 60.0; };
          # transform = { rotation = 0; flipped = false; };
        };

        "HDMI-A-1" = {
          enable = true;
          scale = 1.0;
          position = {
            x = 1920;
            y = 0;
          };
        };
      };

      # --- Layout & Aesthetics ---
      layout = {
        gaps = 0;
        center-focused-column = "on-overflow";
        always-center-single-column = true;
        default-column-width = {};

        struts = {
          left = 0;
          right = 0;
          top = 0;
          bottom = 0;
        };

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
          enable = false;
          width = 2;
          active.color = "#fe8019";
          inactive.color = "#504945";
        };

        border = {
          enable = false;
          width = 2;
          active.color = "#7fc8ff";
          inactive.color = "#404040";
        };

        shadow = {
          enable = false;
        };

        tab-indicator.enable = true;
      };

      window-rules = [
        # 1. Force portals and dialogs to steal focus so Niri pans to them.
        # We explicitly DO NOT use open-floating so they tile and stay anchored.
        {
          matches = [
            {app-id = "^(xdg-desktop-portal.*|polkit-.*)";}
            {title = "^(Open|Save|Choose|Select|Browse).*";}
          ];
          open-focused = true;
          default-column-width = {}; # Let the dialog dictate its own natural width
        }

        # 2. Rounded corners + geometry clip for all windows
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

        # 3. Force full screen width for core productivity apps
        {
          matches = [
            {app-id = "^zen-beta$";}
            {app-id = "^firefox$";}
            {app-id = "^com.mitchellh.ghostty";}
            {app-id = "^emacs";}
          ];
          open-maximized = true;
        }

        # 4. Flat background styling for terminal and editor
        {
          matches = [{app-id = "^ghostty";} {app-id = "^emacs";}];
          draw-border-with-background = false;
        }
        {
          matches = [
            {
              app-id = "^steam$";
              title = "^notificationtoasts_[0-9]+_desktop$";
            }
          ];
          open-floating = true;
          default-floating-position = {
            x = 10;
            y = 10;
            relative-to = "bottom-right";
          };
        }
      ];

      # --- Layer Rules ---
      layer-rules = [
        {
          matches = [{namespace = "^noctalia-overview.*";}];
          shadow.enable = true;
          place-within-backdrop = true;
        }
      ];

      # --- Animations ---
      animations = {
        enable = true;

        workspace-switch.kind.spring = {
          damping-ratio = 1.0;
          stiffness = 1000;
          epsilon = 0.0001;
        };
        horizontal-view-movement.kind.spring = {
          damping-ratio = 1.0;
          stiffness = 800;
          epsilon = 0.0001;
        };
        window-movement.kind.spring = {
          damping-ratio = 1.0;
          stiffness = 800;
          epsilon = 0.0001;
        };
        window-resize.kind.spring = {
          damping-ratio = 1.0;
          stiffness = 800;
          epsilon = 0.0001;
        };
        config-notification-open-close.kind.spring = {
          damping-ratio = 0.6;
          stiffness = 1000;
          epsilon = 0.001;
        };

        window-open.kind.easing = {
          duration-ms = 150;
          curve = "ease-out-expo";
        };
        window-close.kind.easing = {
          duration-ms = 150;
          curve = "ease-out-quad";
        };
        screenshot-ui-open.kind.easing = {
          duration-ms = 200;
          curve = "ease-out-quad";
        };
      };

      # --- Screenshot Path ---
      screenshot-path = "~/Pictures/Screenshots/Screenshot %Y-%m-%d %H-%M-%S.png";

      # --- Key Bindings ---
      binds = {
        # Session Management
        "Mod+Shift+E".action.quit = {};
        "Mod+Shift+P".action.power-off-monitors = {};

        # Applications
        "Mod+Return".action.spawn = ["ghostty"];
        "Mod+W".action.spawn = ["zen-beta"];
        "Mod+E".action.spawn = ["nautilus"];
        "Mod+Shift+Return".action.spawn = ["ghostty" "-e" "nvim"];
        "Ctrl+Shift+Escape".action.spawn = ["missioncenter"];

        # Noctalia Shell Integration
        "Mod+Tab".action.toggle-overview = {};
        "Mod+P".action.spawn = ["noctalia" "msg" "panel-toggle" "launcher"];
        "Alt+Tab".action.spawn = ["noctalia" "msg" "window-switcher"];
        "Mod+Escape".action.spawn = ["noctalia" "msg" "panel-toggle" "session"];
        "Mod+Shift+B".action.spawn = ["noctalia" "msg" "power-cycle"];
        "Mod+Shift+I".action.spawn = ["noctalia" "msg" "caffeine-enable"];

        # Screenshots
        "Print".action.screenshot = {};
        "Shift+Print".action.screenshot-screen = {};
        "Ctrl+Print".action.screenshot-window = {};

        # Window/Column Focus (Vim keys + Arrows)
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

        # Moving Windows/Columns
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

        # Workspace Navigation & Assignment
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

        # Sizing & Presets
        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";

        "Mod+R".action.switch-preset-column-width = {};
        "Mod+Shift+R".action.switch-preset-window-height = {};
        "Mod+F".action.maximize-column = {};
        "Mod+Shift+F".action.fullscreen-window = {};
        "Mod+C".action.center-column = {};

        # Window Stacking (Consume / Expel)
        "Mod+Comma".action.consume-window-into-column = {};
        "Mod+Period".action.expel-window-from-column = {};

        # Window Management (Unstable features noted)
        "Mod+Q".action.close-window = {};
        "Mod+T".action.toggle-window-floating = {};
        "Mod+Shift+T".action.toggle-column-tabbed-display = {};

        # Hardware Media Keys
        "XF86AudioRaiseVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"];
        "XF86AudioLowerVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"];
        "XF86AudioMute".action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
        "XF86AudioMicMute".action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];
        "XF86MonBrightnessUp".action.spawn = ["brightnessctl" "set" "10%+"];
        "XF86MonBrightnessDown".action.spawn = ["brightnessctl" "set" "10%-"];
        "XF86AudioPlay".action.spawn = ["playerctl" "play-pause"];
        "XF86AudioNext".action.spawn = ["playerctl" "next"];
        "XF86AudioPrev".action.spawn = ["playerctl" "previous"];

        # Mouse Wheel Canvas Scrolling
        "Mod+WheelScrollRight".action.focus-column-right = {};
        "Mod+WheelScrollLeft".action.focus-column-left = {};
        "Mod+Shift+WheelScrollRight".action.move-column-right = {};
        "Mod+Shift+WheelScrollLeft".action.move-column-left = {};
        "Mod+WheelScrollDown".action.focus-workspace-down = {};
        "Mod+WheelScrollUp".action.focus-workspace-up = {};
      };

      # --- Startup Programs ---
      spawn-at-startup = [
        {command = ["noctalia"];}
      ];

      # --- Environment & Misc ---
      prefer-no-csd = true;
      hotkey-overlay.skip-at-startup = true;
      xwayland-satellite.enable = true;

      environment = {
        QT_QPA_PLATFORM = "wayland";
        QT_QPA_PLATFORMTHEME = "qt5ct";
        NIXOS_OZONE_WL = "1";
      };
    };
  };
}
