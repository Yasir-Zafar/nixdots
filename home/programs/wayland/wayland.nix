{pkgs, ...}: {
  # Wayland-specific programs and configurations

  # Hyprland configuration through home-manager (complements system installation)
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;

    # Hyprland settings
    settings = {
      # Monitor configuration

      monitor = [
        "eDP-1,1920x1080@60,0x0,1"
        ",highres,auto,1"
        ",addreserved,0,0,0,0"
      ];

      # Input configuration
      input = {
        kb_layout = "us";
        kb_options = "ctrl:nocaps";
        numlock_by_default = true;
        repeat_delay = 500;
        repeat_rate = 50;
        follow_mouse = 1;
        sensitivity = 0.0;
        scroll_factor = 1;
        accel_profile = "adaptive";

        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          tap-to-click = true;
          clickfinger_behavior = true;
          scroll_factor = 1;
        };

        scroll_method = "2fg";
      };

      # General settings
      general = {
        gaps_in = 10;
        gaps_out = 20;

        border_size = 3;
        no_border_on_floating = true;
        "col.active_border" = "rgba(8ec07ccc)";
        "col.inactive_border" = "rgba(83a598cc)";
        # "col.active_border" = " rgba(8ec07cacc) rgba(8ec07cacc) 90deg";
        # "col.inactive_border" = "rgba(83a598cc) rgba(83a598cc) 90deg";

        layout = "master";
        resize_on_border = true;
        hover_icon_on_border = true;
        allow_tearing = false;
        no_focus_fallback = true;

        snap = {
          enabled = true;
        };
      };

      # Decoration settings
      decoration = {
        rounding = 15;
        active_opacity = 0.8;
        inactive_opacity = 0.8;
        dim_inactive = true;
        dim_special = 0.3;

        blur = {
          enabled = true;
          size = 5;
          passes = 3;
          new_optimizations = true;
          xray = true;
          noise = 0.1;
          contrast = 1;
          brightness = 1;
        };

        shadow = {
          enabled = true;
          render_power = 3;
          ignore_window = true;
          range = 12;
          offset = "0 1";
          color = "rgba(16161eff)";
        };
      };

      # Animation settings
      animations = {
        enabled = true;
        first_launch_animation = true;

        bezier = [
          "ease, 0.25, 1, 0.5, 1"
        ];

        animation = [
          "windows, 1, 3, ease, slide"
          "windowsOut, 1, 3, ease, slide"
          "fade, 1, 3, ease"
          "workspaces, 1, 4, ease, slide"
          "border, 1, 10, ease"
        ];
      };

      # Cursor settings
      cursor = {
        inactive_timeout = 3;
      };

      # Layout settings
      dwindle = {
        pseudotile = true;
        preserve_split = true;
        smart_resizing = false;
      };

      # Master layout
      master = {
        new_status = "master";
      };

      # Miscellaneous
      misc = {
        font_family = "JetBrainsMono Nerd Font";
        vfr = true;
        vrr = 1;
        focus_on_activate = true;
        animate_manual_resizes = false;
        animate_mouse_windowdragging = false;
        enable_swallow = true;
        disable_hyprland_logo = true;
        disable_autoreload = true;
        new_window_takes_over_fullscreen = 2;
        force_default_wallpaper = 0;
      };

      # Gestures
      gestures = {
        workspace_swipe = true;
      };

      # Device-specific settings
      device = [
        {
          name = "epic-mouse-v1";
          sensitivity = -0.5;
        }
      ];

      # Variable definitions
      "$mainMod" = "SUPER";
      "$terminal" = "kitty";
      "$browser" = "firefox";
      "$files" = "nautilus";
      "$editor" = "nvim";
      "$reader" = "zathura";

      # Window rules
      windowrule = [
        "float,title:^(Picture-in-Picture)$"
        "float,title:^(Firefox — Sharing Indicator)$"
        "float,title:^(Open File)(.*)$"
        "float,title:^(Select a File)(.*)$"
        "float,title:^(Choose wallpaper)(.*)$"
        "float,title:^(Open Folder)(.*)$"
        "float,title:^(Save As)(.*)$"
        "float,title:^(Library)(.*)$"
      ];

      windowrulev2 = [
        "opacity 0.85 0.85,class:^(mako)$"
      ];

      # Layer rules
      layerrule = [
        "xray 1,.*"
        "noanim,selection"
        "noanim,overview"
        "noanim,noanim"
        "blur,noanim"
        "blur, .hyprpanel-wrap"
        #"ignorealpha 0.8, .hyprpanel-wrap"
        "noanim, .hyprpanel-wrap"
        "blur, rofi"
      ];

      # Key bindings
      bind = [
        # App launchers
        "$mainMod, Return, exec, $terminal"
        "$mainMod, P, exec, rofi -show drun"
        "$mainMod, W, exec, flatpak run app.zen_browser.zen"
        "$mainMod, E, exec, $files"
        "$mainMod, T, exec, $reader"

        # Window management
        "$mainMod, Q, killactive,"
        "$mainMod, F, fullscreen,"
        "$mainMod, Space, togglefloating,"
        "$mainMod SHIFT, Space, togglesplit,"
        "$mainMod SHIFT, P, pseudo,"

        # Window movement
        "$mainMod, left, movewindow, l"
        "$mainMod, right, movewindow, r"
        "$mainMod, up, movewindow, u"
        "$mainMod, down, movewindow, d"

        # Focus movement
        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"

        # Workspace navigation
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        "$mainMod, C, movetoworkspace, special"
        "$mainMod SHIFT, C, togglespecialworkspace"

        # Move window to workspace
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # System commands
        "$mainMod CTRL, Q, exit,"
        "$mainMod SHIFT, R, exec, hyprctl reload"
        "$mainMod, B, exec, hyprpanel toggle bar-0"
        "$mainMod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
        "$mainMod, Backspace, exec, powermenu"

        # Resize submap
        "ALT, R, submap, resize"

        # Screenshots
        ", Print, exec, grimblast copy area"
        "SHIFT, Print, exec, grimblast save area"
        "CTRL, Print, exec, grimblast copy active"
      ];

      # Hardware controls
      bindl = [
        ", XF86AudioMute, exec, pactl set-source-mute 0 toggle || pactl set-source-mute 1 toggle"
      ];

      bindle = [
        ", XF86AudioRaiseVolume, exec, pactl set-sink-mute 0 false ; pactl set-sink-volume 0 +5%"
        ", XF86AudioLowerVolume, exec, pactl set-sink-mute 0 false ; pactl set-sink-volume 0 -5%"
        ", XF86MonBrightnessDown, exec, brightnessctl s 5-%"
        ", XF86MonBrightnessUp, exec, brightnessctl s 5+%"
      ];

      binde = [
        ", XF86AudioPlay, exec, mpc toggle"
        ", XF86AudioNext, exec, mpc next"
        ", XF86AudioPrev, exec, mpc prev"
      ];

      # Submap (resize mode)

      # Mouse bindings
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # Startup applications
      exec-once = [
        "hypridle"
        "hyprpanel"
        "brightnessctl s 55%"
        "easyeffects --gapplication-service"
        "wl-clipboard-history -t"
        "gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'"
        "gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'"
        "gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
      ];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 600;
          on-timeout = "hyprlock";
        }
        {
          timeout = 900;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        no_fade_in = false;
        disable_loading_bar = false;
        grace = 5;
      };
      background = [
        {
          # Use a blurred screenshot as the lock background
          path = "screenshot";
          blur_passes = 4;
          blur_size = 8;
        }
      ];
      input-field = [
        {
          size = "200, 50";
          placeholder_text = "Password...";
          outline_thickness = 2;
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          outer_color = "rgb(151515)";
          inner_color = "rgb(200, 200, 200)";
          font_color = "rgb(10, 10, 10)";
          fade_on_empty = true;
          hide_input = false;
          position = "0, -80";
          halign = "center";
          valign = "center";
        }
      ];
      label = [
        {
          text = "Hi there, boi";
          color = "rgba(200, 200, 200, 1.0)";
          font_size = 25;
          font_family = "DejaVu Sans";
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  dconf.settings = {
    "org/gnome/nautilus/preferences" = {
      show-hidden-files = true;
      default-folder-viewer = "list-view";
      sort-directories-first = true;
    };
  };

  home.packages = with pkgs; [
    # Install Hyprland dependencies
    hypridle
    hyprlock

    # Common utilities for Hyprland
    rofi-wayland
    grim # screenshot functionality
    slurp # screen selection tool
    wl-clipboard

    # Media and audio
    pamixer
    pavucontrol
    glib
    eww
  ];

  # Ensure needed environment variables for Wayland/Hyprland
  home.sessionVariables = {
    NIXOS_OZONE_WL = 1;
    MOZ_ENABLE_WAYLAND = 1;
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    QT_AUTO_SCREEN_SCALE_FACTOR = 1;
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    WLR_NO_HARDWARE_CURSORS = 1;
    HYPRCURSOR_THEME = "Bibata-Modern-Ice";
    HYPRCURSOR_SIZE = 24;
  };
}
