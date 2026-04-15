{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      ghostty
    ];

    file.".config/ghostty/config".text = ''
      background = 282828
      foreground = ebdbb2

      cursor-color = ebdbb2
      cursor-text = 282828

      selection-background = 504945
      selection-foreground = ebdbb2

      palette = 0=#282828
      palette = 1=#cc241d
      palette = 2=#98971a
      palette = 3=#d79921
      palette = 4=#458588
      palette = 5=#b16286
      palette = 6=#689d6a
      palette = 7=#a89984

      palette = 8=#928374
      palette = 9=#fb4934
      palette = 10=#b8bb26
      palette = 11=#fabd2f
      palette = 12=#83a598
      palette = 13=#d3869b
      palette = 14=#8ec07c
      palette = 15=#ebdbb2

      font-family = "JetBrains Mono"
      font-size = 12

      font-style = regular
      font-style-bold = bold
      font-style-italic = italic
      font-style-bold-italic = bold_italic

      font-feature = +liga

      window-decoration = true
      window-theme = dark
      window-colorspace = srgb

      window-width = 100
      window-height = 30
      window-save-state = always

      window-padding-x = 10
      window-padding-y = 8

      title = "Ghostty"

      # launch fish without making it the login shell.
      # zsh remains the login shell; fish inherits the login environment
      # (PATH, env vars) from the zsh session that started the display server.
      command = fish

      # shell-integration tells ghostty to inject its fish integration
      # (prompt marks, title updates, sudo passthrough, cursor shape).
      shell-integration = fish
      shell-integration-features = cursor,sudo,title

      scrollback-limit = 50000

      mouse-hide-while-typing = true
      mouse-shift-capture = true

      copy-on-select = false
      click-repeat-interval = 500

      clipboard-read = allow
      clipboard-write = allow
      clipboard-trim-trailing-spaces = true

      confirm-close-surface = false

      keybind = ctrl+shift+c=copy_to_clipboard
      keybind = ctrl+shift+v=paste_from_clipboard

      keybind = ctrl+shift+n=new_window
      keybind = ctrl+shift+t=new_tab
      keybind = ctrl+shift+w=close_surface

      keybind = ctrl+shift+plus=increase_font_size:1
      keybind = ctrl+shift+minus=decrease_font_size:1
      keybind = ctrl+shift+zero=reset_font_size

      keybind = ctrl+shift+f=toggle_fullscreen

      gtk-tabs-location = top

      minimum-contrast = 1.1

      cursor-style = block
      cursor-style-blink = true
    '';
  };
}
