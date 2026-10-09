# colours and fonts come from stylix (desktop/stylix.nix)
{
  programs.ghostty = {
    enable = true;

    settings = {
      window-decoration = true;
      window-theme = "dark";
      window-colorspace = "srgb";

      window-width = 100;
      window-height = 30;
      window-save-state = "always";

      window-padding-x = 10;
      window-padding-y = 8;

      title = "Ghostty";

      # launch fish without making it the login shell.
      # zsh remains the login shell; fish inherits the login environment
      # (PATH, env vars) from the zsh session that started the display server.
      command = "fish";

      # shell-integration tells ghostty to inject its fish integration
      # (prompt marks, title updates, sudo passthrough, cursor shape).
      shell-integration = "fish";
      shell-integration-features = "cursor,sudo,title";

      font-style = "regular";
      font-style-bold = "bold";
      font-style-italic = "italic";
      font-style-bold-italic = "bold_italic";
      font-feature = "+liga";

      scrollback-limit = 50000;

      mouse-hide-while-typing = true;
      mouse-shift-capture = true;

      copy-on-select = false;
      click-repeat-interval = 500;

      clipboard-read = "allow";
      clipboard-write = "allow";
      clipboard-trim-trailing-spaces = true;

      confirm-close-surface = false;

      keybind = [
        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+shift+v=paste_from_clipboard"

        "ctrl+shift+n=new_window"
        "ctrl+shift+t=new_tab"
        "ctrl+shift+w=close_surface"

        "ctrl+shift+plus=increase_font_size:1"
        "ctrl+shift+minus=decrease_font_size:1"
        "ctrl+shift+zero=reset_font_size"

        "ctrl+shift+f=toggle_fullscreen"
      ];

      gtk-tabs-location = "top";

      minimum-contrast = 1.1;

      cursor-style = "block";
      cursor-style-blink = true;
    };
  };
}
