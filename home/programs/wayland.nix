{ pkgs, ... }:
{
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
        repeat_delay = 600;
        repeat_rate = 50;
        follow_mouse = 1;
        sensitivity = 0.0;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          tap-to-click = true;
          clickfinger_behavior = true;
          scroll_factor = 0.5;
        };
        scroll_method = "2fg";
      };
      
      # General settings
      general = {
        gaps_in = 10;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgba(88c0d0ee) rgba(fb4934ff) 45deg";
        "col.inactive_border" = "rgba(595959aa) rgba(8ec07cff) 45deg";
        layout = "dwindle";
        resize_on_border = false;
        allow_tearing = true;
        no_focus_fallback = true;
      };
      
      # Decoration settings
      decoration = {
        rounding = 10;
        active_opacity = 0.8;
        inactive_opacity = 0.8;
        blur = {
          enabled = true;
          size = 5;
          passes = 3;
          new_optimizations = true;
          noise = 0.03;
          contrast = 0.9;
          brightness = 0.8;
        };
      };
      
      # Animation settings
      animations = {
        enabled = true;
        bezier = [
          "overshot, 0.05, 0.9, 0.1, 1.1"
          "myBezier, 0.05, 0.9, 0.1, 1.05"
        ];
        animation = [
          "windows, 1, 3, overshot"
          "windowsOut, 1, 3, default, popin 80%"
          "border, 1, 5, default"
          "borderangle, 1, 5, default"
          "fade, 1, 3, default"
          "workspaces, 1, 3, overshot"
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
      "$files" = "thunar";
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
      
      # Layer rules
      layerrule = [
        "xray 1,.*"
        "noanim,selection"
        "noanim,overview"
        "noanim,noanim"
        "blur,noanim"
      ];
      
      # Key bindings
      bind = [
        # App launchers
        "$mainMod, Return, exec, $terminal"
        "$mainMod, P, exec, wofi --show drun"
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
        "mako"
        "~/.local/bin/wallpaper-rotator.sh"
        "eww open bar"
        "hypridle"
        "brightnessctl s 55%"
        #"batsignal -b -w 30 -c 15 -d 5 -f 100 -W \"DC NIGGA\" -F \"am too full\" -C \"Kys\""
        "easyeffects --gapplication-service"
        "wl-clipboard-history -t"
        "gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'"
        "gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'"
        "gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice'"
      ];
    };
  };

  # Hypridle Configuration
  home.file.".config/hypr/hypridle.conf".text = ''
    general {
      lock_cmd = "hyprlock"
      unlock_cmd = ""
      before_sleep_cmd = "hyprlock"
      after_sleep_cmd = ""
      ignore_dbus_inhibit = false
    }

    listener {
      timeout = 300
      on_timeout = "hyprlock"
    }

    listener {
      timeout = 600
      on_timeout = "systemctl suspend"
    }

    listener {
      timeout = 1800
      on_timeout = "systemctl hibernate"
    }
  '';
  
  # Hyprlock Configuration
  home.file.".config/hypr/hyprlock.conf".text = ''
    general {
      disable_loading_bar = false
      hide_cursor = true
      grace = 5
    }

    background {
      monitor =
      path = screenshot
      blur_size = 4
      blur_passes = 3
    }

    input-field {
      monitor =
      size = 200, 50
      outline_thickness = 2
      dots_size = 0.2
      dots_spacing = 0.2
      dots_center = true
      outer_color = rgb(151515)
      inner_color = rgb(200, 200, 200)
      font_color = rgb(10, 10, 10)
      fade_on_empty = true
      placeholder_text = <i>Password...</i>
      hide_input = false
      position = 0, -80
      halign = center
      valign = center
    }

    label {
      monitor =
      text = Hi there, $USER
      color = rgba(200, 200, 200, 1.0)
      font_size = 25
      font_family = Noto Sans
      position = 0, 80
      halign = center
      valign = center
    }
  '';
  
  # Other Wayland utilities
  programs = {
    wofi = {
      enable = true;
      settings = {
        width = 500;
        height = 400;
        location = "center";
        show = "drun";
        prompt = "Search...";
        filter_rate = 100;
        allow_markup = true;
        no_actions = true;
        halign = "fill";
        orientation = "vertical";
        content_halign = "fill";
        insensitive = true;
        allow_images = true;
        image_size = 32;
      };
    };
  };

  home.packages = with pkgs; [
    # Install Hyprland dependencies
    hypridle
    hyprlock
    
    # Common utilities for Hyprland
    wofi
    mako       # notifications
    grim       # screenshot functionality
    slurp      # screen selection tool
    wl-clipboard
    
    # Media and audio
    pamixer
    pavucontrol
    glib
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
