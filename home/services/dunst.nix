# home/services/dunst.nix
{ config, lib, pkgs, ... }:

{
  # Configure dunst notification daemon
  services.dunst = {
    enable = true;
    
    settings = {
      global = {
        # Display
        monitor = 0;
        follow = "none";
        width = 300;
        height = 300;
        origin = "top-right";
        offset = "15x45";
        scale = 0;
        notification_limit = 0;
        
        # Progress bar
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;
        
        # UI and text
        indicate_hidden = true;
        transparency = 10;
        separator_height = 2;
        padding = 12;
        horizontal_padding = 12;
        text_icon_padding = 12;
        frame_width = 2;
        separator_color = "frame";
        sort = true;
        font = "Inter 11";
        line_height = 0;
        markup = "full";
        format = "<b>%s</b>\\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = false;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = true;
        
        # Icons
        icon_position = "left";
        min_icon_size = 32;
        max_icon_size = 64;
        icon_path = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark/16x16/status/:${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark/16x16/devices/:${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark/16x16/apps/";
        
        # History
        sticky_history = true;
        history_length = 20;
        
        # Misc
        browser = "${pkgs.firefox}/bin/firefox -new-tab";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        corner_radius = 10;
        ignore_dbusclose = false;
        force_xwayland = false;
        force_xinerama = false;
        
        # Mouse
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "context";
      };
      
      # Urgency levels
      urgency_low = {
        background = "#1E1E2E";
        foreground = "#CDD6F4";
        frame_color = "#89B4FA";
        timeout = 10;
      };
      
      urgency_normal = {
        background = "#1E1E2E";
        foreground = "#CDD6F4";
        frame_color = "#89B4FA";
        timeout = 10;
      };
      
      urgency_critical = {
        background = "#1E1E2E";
        foreground = "#CDD6F4";
        frame_color = "#F38BA8";
        timeout = 0;
      };
    };
  };
}
