# ===== GHOSTTY WITH GRUVBOX THEME =====
# Location: hm/applications/ghostty.nix
{
  config,
  pkgs,
  ...
}: {
  home = {
    # Install Ghostty terminal
    packages = with pkgs; [
      ghostty
    ];

    # Ghostty configuration
    file.".config/ghostty/config".text = ''
      # ===== GRUVBOX DARK THEME =====

      # Background and foreground
      background = 282828
      foreground = ebdbb2

      # Cursor colors
      cursor-color = ebdbb2
      cursor-text = 282828

      # Selection colors
      selection-background = 504945
      selection-foreground = ebdbb2

      # ===== FONT CONFIGURATION =====

      # Font family and size
      font-family = "JetBrains Mono"
      font-size = 12

      # Font variations
      font-style = regular
      font-style-bold = bold
      font-style-italic = italic
      font-style-bold-italic = bold_italic

      # Font features
      font-feature = -liga  # Disable ligatures if you don't want them
      # font-feature = +liga # Enable ligatures

      # ===== WINDOW CONFIGURATION =====

      # Window appearance
      window-decoration = true
      window-theme = dark
      window-colorspace = srgb

      # Window size and behavior
      window-width = 100
      window-height = 30
      window-save-state = always

      # Window padding (add space around terminal content)
      window-padding-x = 15
      window-padding-y = 15

      # Window title
      title = "Ghostty"

      # ===== TERMINAL BEHAVIOR =====

      # Shell
      shell-integration = zsh
      shell-integration-features = cursor,sudo,title

      # Scrollback
      scrollback-limit = 10000

      # Mouse support
      mouse-hide-while-typing = true
      mouse-shift-capture = true

      # Copy/paste behavior
      copy-on-select = true
      click-repeat-interval = 500

      # ===== ADVANCED FEATURES =====

      # Clipboard
      clipboard-read = allow
      clipboard-write = allow
      clipboard-trim-trailing-spaces = true

      # Confirm before closing
      confirm-close-surface = false

      # Custom key bindings (Gruvbox-themed shortcuts)
      keybind = ctrl+shift+c=copy_to_clipboard
      keybind = ctrl+shift+v=paste_from_clipboard
      keybind = ctrl+shift+n=new_window
      keybind = ctrl+shift+t=new_tab
      keybind = ctrl+shift+w=close_surface
      keybind = ctrl+shift+plus=increase_font_size:1
      keybind = ctrl+shift+minus=decrease_font_size:1
      keybind = ctrl+shift+zero=reset_font_size
      keybind = ctrl+shift+f=toggle_fullscreen

      # Tab configuration
      gtk-tabs-location = top

      # ===== GRUVBOX-SPECIFIC TWEAKS =====

      # Adjust contrast for better readability
      minimum-contrast = 1.1

      # Cursor style that works well with Gruvbox
      cursor-style = block
      cursor-style-blink = true
    '';
  };

  # ===== ALTERNATIVE GRUVBOX LIGHT THEME =====
  # Uncomment this section if you prefer light theme

  # home.file.".config/ghostty/gruvbox-light.conf".text = ''
  #   # Background and foreground (light theme)
  #   background = fbf1c7
  #   foreground = 3c3836
  #
  #   # Cursor colors (light theme)
  #   cursor-color = 3c3836
  #   cursor-text = fbf1c7
  #
  #   # Selection colors (light theme)
  #   selection-background = d5c4a1
  #   selection-foreground = 3c3836
  #
  #   # Normal colors (0-7) - Light theme
  #   palette = 0=#fbf1c7   # black (light bg)
  #   palette = 1=#cc241d   # red
  #   palette = 2=#98971a   # green
  #   palette = 3=#d79921   # yellow
  #   palette = 4=#458588   # blue
  #   palette = 5=#b16286   # magenta
  #   palette = 6=#689d6a   # cyan
  #   palette = 7=#7c6f64   # white
  #
  #   # Bright colors (8-15) - Light theme
  #   palette = 8=#928374   # bright black
  #   palette = 9=#9d0006   # bright red
  #   palette = 10=#79740e  # bright green
  #   palette = 11=#b57614  # bright yellow
  #   palette = 12=#076678  # bright blue
  #   palette = 13=#8f3f71  # bright magenta
  #   palette = 14=#427b58  # bright cyan
  #   palette = 15=#3c3836  # bright white (light fg)
  # '';
}
