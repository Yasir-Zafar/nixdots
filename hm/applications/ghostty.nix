# ===== GHOSTTY WITH GRUVBOX THEME =====
# Location: hm/applications/ghostty.nix
{
  config,
  pkgs,
  ...
}:
{
  # Install Ghostty terminal
  home.packages = with pkgs; [
    ghostty
  ];

  # Ghostty configuration
  home.file.".config/ghostty/config".text = ''
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

    # Normal colors (0-7)
    palette = 0=#282828   # black
    palette = 1=#cc241d   # red
    palette = 2=#98971a   # green
    palette = 3=#d79921   # yellow
    palette = 4=#458588   # blue
    palette = 5=#b16286   # magenta
    palette = 6=#689d6a   # cyan
    palette = 7=#a89984   # white

    # Bright colors (8-15)
    palette = 8=#928374   # bright black
    palette = 9=#fb4934   # bright red
    palette = 10=#b8bb26  # bright green
    palette = 11=#fabd2f  # bright yellow
    palette = 12=#83a598  # bright blue
    palette = 13=#d3869b  # bright magenta
    palette = 14=#8ec07c  # bright cyan
    palette = 15=#ebdbb2  # bright white

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

    # Image support (if you want inline images)
    image-storage-limit = 320000000  # 320MB

    # Clipboard
    clipboard-read = allow
    clipboard-write = allow
    clipboard-trim-trailing-spaces = true

    # Bracketed paste
    bracketed-paste = true

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

    # Underline colors for better visibility
    underline-color = d79921  # Gruvbox yellow
    underline-thickness = 1px

    # Bell configuration (subtle for Gruvbox theme)
    bell = false
    visual-bell = false
  '';

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

  # Set Ghostty as default terminal
  home.sessionVariables = {
    TERMINAL = "ghostty";
  };
}
# ===== INTEGRATION WITH ZSH =====
# Add to your existing zsh config (hm/development/shell/zsh.nix)
{
  programs.zsh = {
    # ... existing config ...

    sessionVariables = {
      # ... existing variables ...

      # Ghostty-specific variables
      TERM = "xterm-256color";
      COLORTERM = "truecolor";

      # Enable better Ghostty integration
      GHOSTTY_RESOURCES_DIR = "${pkgs.ghostty}/share/ghostty";
    };

    initExtra = ''
      # ... existing init ...

      # Ghostty-specific shell integration
      if [[ "$TERM" == "xterm-ghostty" || "$GHOSTTY_RESOURCES_DIR" != "" ]]; then
        # Enable Ghostty shell integration features
        builtin source ${pkgs.ghostty}/etc/ghostty/shell-integration/zsh
      fi

      # Gruvbox-themed aliases for Ghostty
      alias ghostty-light='ghostty --config ~/.config/ghostty/gruvbox-light.conf'
      alias ghostty-dark='ghostty --config ~/.config/ghostty/config'  # default
    '';
  };
}
# ===== DESKTOP INTEGRATION =====
# Add to hm/applications/default.nix
{
  imports = [
    ./browsers.nix
    ./media.nix
    ./utilities.nix
    ./ghostty.nix # <- Add this import
  ];

  # Set Ghostty as the default terminal application
  xdg.mimeApps = {
    defaultApplications = {
      "application/x-terminal-emulator" = "com.mitchellh.ghostty.desktop";
    };
  };
}
# ===== GNOME INTEGRATION =====
# If using GNOME, add to hm/desktop/gnome-settings.nix
{
  dconf.settings = {
    # Set Ghostty as default terminal in GNOME
    "org/gnome/desktop/applications/terminal" = {
      exec = "ghostty";
    };

    # GNOME keyboard shortcuts for Ghostty
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Open Ghostty Terminal";
      command = "ghostty";
      binding = "<Control><Alt>t";
    };
  };
}
# ===== STARSHIP INTEGRATION =====
# Enhance your starship config for better Ghostty support
{
  programs.starship = {
    # ... existing config ...

    settings = {
      # ... existing settings ...

      # Better colors for Gruvbox theme in Ghostty
      character = {
        success_symbol = "[❯](bold #b8bb26)"; # Gruvbox green
        error_symbol = "[❯](bold #fb4934)"; # Gruvbox red
        vimcmd_symbol = "[❮](bold #fabd2f)"; # Gruvbox yellow
      };

      directory = {
        style = "bold #83a598"; # Gruvbox blue
      };

      git_branch = {
        style = "bold #b8bb26"; # Gruvbox green
      };

      git_status = {
        style = "bold #fabd2f"; # Gruvbox yellow
      };
    };
  };
}
# ===== ADDITIONAL GRUVBOX TOOLS =====
# Add some complementary packages for a complete Gruvbox experience
{
  home.packages = with pkgs; [
    # ... existing packages ...

    # Gruvbox-themed tools
    bat # Modern cat with Gruvbox theme support
    delta # Git diff with Gruvbox colors
    eza # Modern ls with color support

    # Additional fonts that work well with Gruvbox
    (nerdfonts.override {
      fonts = ["JetBrainsMono" "FiraCode" "Hack"];
    })
  ];

  # Configure bat to use Gruvbox theme
  programs.bat = {
    enable = true;
    config = {
      theme = "gruvbox-dark";
      style = "numbers,changes,header";
    };
  };

  # Configure git delta for Gruvbox colors
  programs.git = {
    delta = {
      enable = true;
      options = {
        features = "gruvbox-dark";
        syntax-theme = "gruvbox-dark";
      };
    };
  };
}
# ===== USAGE INSTRUCTIONS =====
/*
After adding this configuration:

1. Rebuild Home Manager:
   home-manager switch --flake ~/nix-config/hm

2. Launch Ghostty:
   ghostty

3. The terminal will automatically use the Gruvbox dark theme!

4. Keyboard shortcuts in Ghostty:
   - Ctrl+Shift+C: Copy
   - Ctrl+Shift+V: Paste
   - Ctrl+Shift+T: New tab
   - Ctrl+Shift+N: New window
   - Ctrl+Shift+Plus: Increase font size
   - Ctrl+Shift+Minus: Decrease font size
   - Ctrl+Shift+F: Toggle fullscreen

5. To switch themes:
   ghostty-light   # Light Gruvbox theme
   ghostty-dark    # Dark Gruvbox theme (default)

6. Configuration file location:
   ~/.config/ghostty/config
*/

