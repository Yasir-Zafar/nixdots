{

  home = { 

    sessionVariables = {

      # wayland
      QT_QPA_PLATFORM="wayland";

      # Fixing Paths
      QT_QPA_PLATFORMTHEME="qt5ct";
      MOZ_USE_XINPUT2="1";
      GTK_THEME="Gruvbox-Dark-B";

      # Default Apps
      EDITOR = "emacsclient -c -a 'emacs'";
      ALTERNATE_EDITOR="nvim";
      TERMINAL="foot";
      READER="evince";
      BROWSER="firefox";
      VIDEO="mpv";
      IMAGE="imv";
      COLORTERM="truecolor";
      OPENER="xdg-open";
      WM="Hyprland";

    };

  };

}
