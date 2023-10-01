{ pkgs, ... }:
{

  gtk = {

    enable = true;
    theme = {

      name = "Gruvbox-Dark-B";
      package = pkgs.gruvbox-gtk-theme;

    };

    iconTheme = {

      name = "oomox-gruvbox-dark";
      package = pkgs.gruvbox-dark-icons-gtk;

    };

    font = {

      name = "JetBrainsMono 10";

    };

    cursorTheme = {

      name = "macOS-BigSur";
      package = pkgs.apple-cursor;

    };

  };

}
