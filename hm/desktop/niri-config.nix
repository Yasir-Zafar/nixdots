{
  pkgs,
  lib,
  ...
}: {
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
          # accel-profile = "adaptive";
          dwt = true;
          # dwtp = true;
          # click-method = "clickfinger";
        };

        mouse = {
          natural-scroll = false;
          accel-speed = 0.5;
          scroll-factor = 1.0;
        };

        tablet = {
          map-to-output = "eDP-1";
        };

        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "20%";
        };
        workspace-auto-back-and-forth = true;
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
          variable-refresh-rate = "on-demand";
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

      # ------------------------------------------------------------------ #
      # LAYOUT                                                               #
      # ------------------------------------------------------------------ #
      layout = {
        gaps = 0;

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
          enable = false;
          width = 2;
          active.color = "#fe8019"; # bright-orange
          inactive.color = "#504945"; # bg2
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

        always-center-single-column = true;
      };

      # ------------------------------------------------------------------ #
      # WORKSPACES (named)                                                   #
      # ------------------------------------------------------------------ #
      workspaces = {
        "1" = {};
        "2" = {};
        "3" = {};
        "4" = {};
        "5" = {};
      };

      # ------------------------------------------------------------------ #
      # CURSOR                                                               #
      # ------------------------------------------------------------------ #
      cursor = {
        theme = "Bibata-Modern-Classic";
        size = 24;
        hide-when-typing = false;
        hide-after-inactive-ms = 5000;
      };

      # ------------------------------------------------------------------ #
      # WINDOW RULES                                                         #
      # ------------------------------------------------------------------ #
      window-rules = [
        # floating dialogs — is-dialog is niri-unstable only;
        # use app-id regex for stable
        {
          matches = [{app-id = "^(xdg-desktop-portal|polkit)";}];
          open-floating = true;
        }

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
        {
          matches = [
            {app-id = "^zen-beta$";}
            {app-id = "^firefox$";}
            {app-id = "^ghostty";}
            {app-id = "^emacs";}
          ];
          # This makes the column take up 100% of the screen width
          default-column-width = {proportion = 1.0;};
        }
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
          default-floating-position = {
            x = 10;
            y = 10;
            relative-to = "bottom-right";
          };
        }
      ];

      # ------------------------------------------------------------------ #
      # LAYER RULES                                                          #
      # ------------------------------------------------------------------ #
      layer-rules = [
        {
          matches = [{namespace = "^noctalia-overview*";}];
          shadow.enable = true;
          place-within-backdrop = true;
        }
      ];

      # ------------------------------------------------------------------ #
      # ANIMATIONS                                                           #
      # ------------------------------------------------------------------ #
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
        "Mod+Shift+Return".action.spawn = ["ghostty" "-e" "nvim"];
        "Ctrl+Shift+Escape".action.spawn = ["missioncenter"];

        # -- noctalia --
        "Mod+Tab".action.toggle-overview = {};
        "Mod+P".action.spawn = ["noctalia-shell" "ipc" "call" "launcher" "toggle"];
        "Alt+Tab".action.spawn = ["noctalia-shell" "ipc" "call" "launcher" "windows"];
        "Mod+Escape".action.spawn = ["noctalia-shell" "ipc" "call" "sessionMenu" "toggle"];

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
        {command = ["noctalia-shell"];}
      ];

      # ------------------------------------------------------------------ #
      # MISC                                                                 #
      # ------------------------------------------------------------------ #
      prefer-no-csd = true;

      hotkey-overlay.skip-at-startup = true;

      environment = {
        QT_QPA_PLATFORM = "wayland";
        QT_QPA_PLATFORMTHEME = "gtk3";
        NIXOS_OZONE_WL = "1";
      };

      xwayland-satellite = {
        enable = true;
      };
    };
  };
}
