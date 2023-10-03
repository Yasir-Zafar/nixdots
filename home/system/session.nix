{

  home = { 

    sessionVariables = {

      EDITOR = "emacsclient -c -a 'emacs'";
      ALTERNATE_EDITOR="nvim";
      TERMINAL="foot";
      READER="evince";
      BROWSER="firefox";

      # wayland
      QT_QPA_PLATFORM="wayland";

      # Fixing Paths
      QT_QPA_PLATFORMTHEME="qt5ct";
      MOZ_USE_XINPUT2="1";
      GTK_THEME="Gruvbox-Dark-B";

      # Default Apps
      VIDEO="mpv";
      IMAGE="imv";
      COLORTERM="truecolor";
      OPENER="xdg-open";
      WM="Hyprland";

      # Use neovim as manpage pager.
      MANPAGER="nvim +Man!";

    };

  };

}
