{

  home = { 

    sessionVariables = {

      # Fixing Paths
      MOZ_USE_XINPUT2="1";
      GTK_THEME="Gruvbox-Dark-B";

      # Default Apps
      EDITOR = "emacsclient -c -a 'emacs'";
      ALTERNATE_EDITOR="nvim";
      TERMINAL="foot";
      READER="emacs";
      BROWSER="firefox";
      VIDEO="mpv";
      IMAGE="imv";
      COLORTERM="truecolor";
      OPENER="xdg-open";
      #WM="Hyprland";

      #_JAVA_AWT_WM_NONREPARENTING = "1";
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORMTHEME = "gtk3";
      QT_SCALE_FACTOR = "1";
      QT_QPA_PLATFORM = "wayland";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";

      #WLR_RENDERER = "vulkan";
      #XDG_CURRENT_DESKTOP = "Hyprland";
      #XDG_SESSION_DESKTOP = "Hyprland";
      #XDG_SESSION_TYPE = "wayland";
      #GTK_USE_PORTAL = "1";
      #NIXOS_XDG_OPEN_USE_PORTAL = "1";

    };

  };

}
