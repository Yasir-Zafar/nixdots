{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./nixvim
  ];

  # # Manage dotfiles through Home Manager
  # home.file = {
  #   # Custom configuration files
  #   ".config/user-dirs.dirs".source = ./config/user-dirs.dirs;
  #
  #   # Custom themes or configurations
  #   ".themes".source = ./config/themes;
  #   ".icons".source = ./config/icons;
  # };
  #
  # # XDG configuration
  # xdg = {
  #   enable = true;
  #
  #   # Configure XDG directories
  #   userDirs = {
  #     enable = true;
  #     createDirectories = true;
  #
  #     # Custom directory names (optional)
  #     desktop = "${config.home.homeDirectory}/Desktop";
  #     documents = "${config.home.homeDirectory}/Documents";
  #     download = "${config.home.homeDirectory}/Downloads";
  #     music = "${config.home.homeDirectory}/Music";
  #     pictures = "${config.home.homeDirectory}/Pictures";
  #     videos = "${config.home.homeDirectory}/Videos";
  #     templates = "${config.home.homeDirectory}/Templates";
  #     publicShare = "${config.home.homeDirectory}/Public";
  #   };
  #
  #   # MIME type associations
  #   mimeApps = {
  #     enable = true;
  #     defaultApplications = {
  #       "text/plain" = "nvim.desktop";
  #       "text/html" = "firefox.desktop";
  #       "application/pdf" = "org.gnome.Evince.desktop";
  #       "image/jpeg" = "org.gnome.eog.desktop";
  #       "image/png" = "org.gnome.eog.desktop";
  #       "video/mp4" = "vlc.desktop";
  #       "audio/mpeg" = "vlc.desktop";
  #     };
  #   };
  # };
}
