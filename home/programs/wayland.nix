{ config, lib, pkgs, ... }:

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
        ",preferred,auto,1"
      ];
      
      # Input configuration
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0.0;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          tap-to-click = true;
        };
      };
      
      # General settings
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(88c0d0ee)";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
        allow_tearing = false;
      };
      
      # Decoration settings
      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          new_optimizations = true;
        };
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };
      
      # Animation settings
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };
      
      # Layout settings
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      
      # Gestures
      gestures = {
        workspace_swipe = true;
      };
      
      # Window rules
      windowrule = [
        "float,^(pavucontrol)$"
        "float,^(blueman-manager)$"
        "float,^(nm-connection-editor)$"
        "float,^(file-roller)$"
        "float,title:^(Picture-in-Picture)$"
        "float,title:^(Firefox — Sharing Indicator)$"
      ];
      
      # Basic key bindings
      "$mainMod" = "SUPER";
      bind = [
        # App launchers
        "$mainMod, Return, exec, kitty"
        "$mainMod, D, exec, wofi --show drun"
        "$mainMod, B, exec, firefox"
        "$mainMod, E, exec, thunar"
        
        # Window management
        "$mainMod, Q, killactive,"
        "$mainMod, F, fullscreen,"
        "$mainMod, Space, togglefloating,"
        "$mainMod SHIFT, Space, togglesplit,"
        
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
        
        # Window focus
        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"
        
        # System commands
        "$mainMod CTRL, Q, exit,"
        "$mainMod SHIFT, R, exec, hyprctl reload"
        
        # Screenshots
        ", Print, exec, grimblast copy area"
        "SHIFT, Print, exec, grimblast save area"
        "CTRL, Print, exec, grimblast copy active"
      ];
      
      # Mouse bindings
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      
      # Startup applications
      exec-once = [
        "mako"
        #"swww init && swww img ~/Pictures/Wallpapers/current.jpg"
        #"nm-applet --indicator"
        #"blueman-applet"
        "/usr/lib/polkit-kde-authentication-agent-1"
        "wl-clipboard-history -t"
        #"swayidle -w timeout 300 'swaylock' timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'"
      ];
    };
  };
  
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
    
  
  # Ensure needed environment variables for Wayland/Hyprland
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    XDG_SESSION_TYPE = "wayland";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    GDK_BACKEND = "wayland,x11";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
  };
}
