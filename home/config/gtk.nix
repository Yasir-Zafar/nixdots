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

      name = "JetBrainsMono Nerd Font 10";

    };

    cursorTheme = {

      name = "Capitaine Cursors (Gruvbox) - White";
      package = pkgs.capitaine-cursors-themed;

    };

  };

}
