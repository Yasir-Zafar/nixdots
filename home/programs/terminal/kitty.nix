# Add this to your home.nix file

{ config, pkgs, lib, ... }:

{
  programs.kitty = {
    enable = true;
    
    # General settings
    settings = {
      # Font configuration
      font_family = "JetBrains Mono";
      bold_font = "JetBrains Mono Bold";
      italic_font = "JetBrains Mono Italic";
      bold_italic_font = "JetBrains Mono Bold Italic";
      font_size = 12;
      adjust_line_height = "110%";
      
      # Window appearance
      window_padding_width = "10";
      hide_window_decorations = "yes";
      confirm_os_window_close = 0;  # Terminal closing confirmation already disabled
      background_opacity = "0.8";
      dynamic_background_opacity = "yes";
      
      # Terminal bell
      enable_audio_bell = "no";
      visual_bell_duration = "0.0";
      window_alert_on_bell = "yes";
      
      # Scrollback
      scrollback_lines = 10000;
      wheel_scroll_multiplier = "5.0";
      touch_scroll_multiplier = "1.0";
      
      # Mouse
      mouse_hide_wait = "2.0";
      url_style = "curly";
      open_url_with = "default";
      url_prefixes = "http https file ftp gemini";
      detect_urls = "yes";
      copy_on_select = "clipboard";
      
      # Performance
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = "yes";
      
      # Terminal environment
      term = "xterm-kitty";
      shell_integration = "enabled";
      
      # Cursor
      cursor_shape = "block";
      cursor_blink_interval = "0.5";
      cursor_beam_thickness = "1.5";
      cursor_underline_thickness = "2.0";
      
      # Keyboard
      map_resize_window = "shift+alt+r";
      map_kitty_shell = "ctrl+shift+escape";
      
      # Tab bar - enhanced appearance
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "round";
      tab_bar_min_tabs = 1;
      tab_bar_margin_width = 4;
      tab_bar_margin_height = "4.0 0.0";
      active_tab_font_style = "bold";
      inactive_tab_font_style = "normal";
      tab_activity_symbol = "◉";
      tab_title_template = "{activity_symbol}{index}: {title}";
      active_tab_title_template = "{index}: {title}";
      
      # Color scheme - Gruvbox Dark
      foreground = "#ebdbb2";
      background = "#282828";
      selection_foreground = "#282828";
      selection_background = "#ebdbb2";
      url_color = "#83a598";
      cursor = "#ebdbb2";
      
      # Normal colors
      color0 = "#282828";   # black
      color1 = "#cc241d";   # red
      color2 = "#98971a";   # green
      color3 = "#d79921";   # yellow
      color4 = "#458588";   # blue
      color5 = "#b16286";   # magenta
      color6 = "#689d6a";   # cyan
      color7 = "#a89984";   # white
      
      # Bright colors
      color8 = "#928374";   # bright black
      color9 = "#fb4934";   # bright red
      color10 = "#b8bb26";  # bright green
      color11 = "#fabd2f";  # bright yellow
      color12 = "#83a598";  # bright blue
      color13 = "#d3869b";  # bright magenta
      color14 = "#8ec07c";  # bright cyan
      color15 = "#ebdbb2";  # bright white
      
      # Extended Gruvbox colors
      color16 = "#fe8019";  # orange
      color17 = "#d65d0e";  # hard orange
      color18 = "#3c3836";  # bg1
      color19 = "#504945";  # bg2
      color20 = "#bdae93";  # fg2
      color21 = "#ebdbb2";  # fg1
    };
    
    # Key mappings
    keybindings = {
      # Window management
      "ctrl+shift+n" = "new_os_window";
      "ctrl+shift+w" = "close_window";
      "ctrl+shift+enter" = "new_window";
      
      # Tab management
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+q" = "close_tab";
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";
      
      # Font size
      "ctrl+shift+equal" = "increase_font_size";
      "ctrl+shift+minus" = "decrease_font_size";
      "ctrl+shift+backspace" = "restore_font_size";
      
      # Clipboard
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
      
      # Scrolling
      "ctrl+shift+up" = "scroll_line_up";
      "ctrl+shift+down" = "scroll_line_down";
      "ctrl+shift+page_up" = "scroll_page_up";
      "ctrl+shift+page_down" = "scroll_page_down";
      "ctrl+shift+home" = "scroll_home";
      "ctrl+shift+end" = "scroll_end";
      
      # Miscellaneous
      "ctrl+shift+f" = "toggle_fullscreen";
      "ctrl+shift+l" = "clear_terminal reset active";
    };
    
    # Extra configuration files
    extraConfig = ''
      # Include additional configuration files
      # include ./theme.conf
      
      # Shell integration
      shell_integration enabled
      
      # Remote control
      allow_remote_control yes
      listen_on unix:/tmp/kitty
      
      # Tab bar colors - Gruvbox themed
      active_tab_foreground   #282828
      active_tab_background   #fabd2f
      active_tab_font_style   bold
      inactive_tab_foreground #ebdbb2
      inactive_tab_background #504945
      inactive_tab_font_style normal
      tab_bar_background      #3c3836
    '';
  };
}
