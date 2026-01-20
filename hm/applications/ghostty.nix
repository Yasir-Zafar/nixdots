# ============================================================================
# Ghostty Terminal Emulator Configuration
# Location: hm/applications/ghostty.nix
# ============================================================================
# Ghostty is a modern, GPU-accelerated terminal emulator.
# This configuration applies a Gruvbox Dark color scheme.
# ============================================================================
{pkgs, ...}: {
  home = {
    # Install Ghostty
    packages = with pkgs; [
      ghostty
    ];

    # ========================================================================
    # Ghostty Configuration File
    # ========================================================================
    file.".config/ghostty/config".text = ''
      # ======================================================================
      # COLOR SCHEME - Gruvbox Dark
      # ======================================================================
      # Background and foreground
      background = 282828
      foreground = ebdbb2

      # Cursor colors
      cursor-color = ebdbb2
      cursor-text = 282828

      # Selection colors
      selection-background = 504945
      selection-foreground = ebdbb2
      # Normal colors
      palette = 0=#282828
      palette = 1=#cc241d
      palette = 2=#98971a
      palette = 3=#d79921
      palette = 4=#458588
      palette = 5=#b16286
      palette = 6=#689d6a
      palette = 7=#a89984

      # Bright colors
      palette = 8=#928374
      palette = 9=#fb4934
      palette = 10=#b8bb26
      palette = 11=#fabd2f
      palette = 12=#83a598
      palette = 13=#d3869b
      palette = 14=#8ec07c
      palette = 15=#ebdbb2

      # ======================================================================
      # FONT CONFIGURATION
      # ======================================================================
      font-family = "JetBrains Mono"
      font-size = 12

      # Font variations
      font-style = regular
      font-style-bold = bold
      font-style-italic = italic
      font-style-bold-italic = bold_italic

      # Font features
      font-feature = +liga

      # ======================================================================
      # WINDOW CONFIGURATION
      # ======================================================================
      # Window appearance
      window-decoration = true
      window-theme = dark
      window-colorspace = srgb

      # Window size (in characters)
      window-width = 100
      window-height = 30
      window-save-state = always

      # Window padding (space around terminal content)
      window-padding-x = 10
      window-padding-y = 8

      # Window title
      title = "Ghostty"

      # ======================================================================
      # TERMINAL BEHAVIOR
      # ======================================================================
      # Shell integration
      shell-integration = zsh
      shell-integration-features = cursor,sudo,title

      # Scrollback buffer
      scrollback-limit = 50000

      # Mouse behavior
      mouse-hide-while-typing = true
      mouse-shift-capture = true

      # Copy/paste
      copy-on-select = false
      click-repeat-interval = 500

      # ======================================================================
      # CLIPBOARD & SECURITY
      # ======================================================================
      clipboard-read = allow
      clipboard-write = allow
      clipboard-trim-trailing-spaces = true

      # Close confirmation
      confirm-close-surface = false

      # ======================================================================
      # KEYBOARD SHORTCUTS
      # ======================================================================
      # Clipboard operations
      keybind = ctrl+shift+c=copy_to_clipboard
      keybind = ctrl+shift+v=paste_from_clipboard

      # Window & tab management
      keybind = ctrl+shift+n=new_window
      keybind = ctrl+shift+t=new_tab
      keybind = ctrl+shift+w=close_surface

      # Font size control
      keybind = ctrl+shift+plus=increase_font_size:1
      keybind = ctrl+shift+minus=decrease_font_size:1
      keybind = ctrl+shift+zero=reset_font_size

      # Fullscreen
      keybind = ctrl+shift+f=toggle_fullscreen

      # ======================================================================
      # TAB CONFIGURATION
      # ======================================================================
      gtk-tabs-location = top

      # ======================================================================
      # VISUAL ENHANCEMENTS
      # ======================================================================
      # Contrast adjustment for better readability
      minimum-contrast = 1.1

      # Cursor style
      cursor-style = block
      cursor-style-blink = true
    '';
  };
}
# ============================================================================
# CUSTOMIZATION SUGGESTIONS
# ============================================================================
# 1. Enable ligatures: Change font-feature to +liga
# 2. Add full Gruvbox color palette for better color support
# 3. Adjust window-padding for tighter/looser spacing
# 4. Change shell-integration if using bash/fish instead of zsh
# 5. Create additional theme files for quick switching
# ============================================================================

