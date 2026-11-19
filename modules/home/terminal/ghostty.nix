# colours and fonts come from stylix (desktop/stylix.nix)
{lib, ...}: {
  programs.ghostty = {
    enable = true;

    settings = {
      window-decoration = true;
      window-theme = "dark";

      window-width = 100;
      window-height = 30;

      window-padding-x = 10;
      window-padding-y = 8;
      window-padding-balance = true;

      # no fixed `title`: it would override the shell-integration title updates below

      # launch fish without making it the login shell.
      # zsh remains the login shell; fish inherits the login environment
      # (PATH, env vars) from the zsh session that started the display server.
      command = "fish";

      # shell-integration tells ghostty to inject its fish integration
      # (prompt marks, title updates, sudo passthrough, cursor shape).
      shell-integration = "fish";
      shell-integration-features = "cursor,sudo,title";

      # as in the original config: stylix would add a "Noto Color Emoji" family
      # here, which breaks emoji rendering; let fontconfig fall back instead
      font-family = lib.mkForce "JetBrainsMono Nerd Font Mono";

      font-style = "regular";
      font-style-bold = "bold";
      font-style-italic = "italic";
      font-style-bold-italic = "bold_italic";
      font-feature = "+liga";

      # no scrollback setting: the default is 50 MB (unlimited lines). The old
      # `scrollback-limit = 50000` was bytes, about 1000x less than that

      mouse-hide-while-typing = true;
      mouse-shift-capture = true;

      copy-on-select = false;
      click-repeat-interval = 500;

      clipboard-read = "allow";

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

      minimum-contrast = 1.1;

      cursor-style-blink = true;
    };
  };
}
