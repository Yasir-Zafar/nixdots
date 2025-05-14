{pkgs, ...}: {
  import = [
    ./rofi.nix
  ];

  # Productivity applications
  home.packages = with pkgs; [
    # Note taking
    obsidian

    # Office suite
    libreoffice

    # PDF tools
    poppler_utils

    # Time management
    gnome-calendar

    # System monitoring
    btop
    htop

    # Calculator
    gnome-calculator
  ];

  # Configure Zathura as a PDF reader
  programs.zathura = {
    enable = true;
    options = {
      recolor = true;
      recolor-keephue = true;
      selection-clipboard = "clipboard";
      font = "JetBrainsMono Nerd Font 10";
      default-bg = "#282a36";
      default-fg = "#f8f8f2";
      recolor-darkcolor = "#f8f8f2";
      recolor-lightcolor = "#282a36";
      inputbar-bg = "#282a36";
      inputbar-fg = "#f8f8f2";
      statusbar-bg = "#282a36";
      statusbar-fg = "#f8f8f2";
    };
  };

  # rofi source
  home.file.".config/rofi".source = ./../../../config/rofi;
}
