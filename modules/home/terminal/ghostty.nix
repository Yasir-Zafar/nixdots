# colours and fonts come from stylix (desktop/stylix.nix)
{lib, ...}: {
  programs.ghostty = {
    enable = true;

    settings = {
      window-decoration = true;
      window-theme = "dark";

      window-width = 100;
      window-height = 30;

      window-padding-x = 14;
      window-padding-y = 12;
      window-padding-balance = true;

      # no fixed `title`: it would override the shell-integration title updates below

      # fish here, zsh stays the login shell
      command = "fish";

      shell-integration = "fish";
      shell-integration-features = "cursor,sudo,title";

      # stylix's "Noto Color Emoji" family breaks emoji; let fontconfig fall back
      font-family = lib.mkForce "JetBrainsMono Nerd Font Mono";

      font-style = "regular";
      font-style-bold = "bold";
      font-style-italic = "italic";
      font-style-bold-italic = "bold_italic";
      font-feature = "+liga";

      # scrollback: default 50 MB

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
