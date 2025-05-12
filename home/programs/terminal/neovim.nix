{ config, lib, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # Path to your existing Neovim config directory
  home.file = {
    ".config/nvim" = {
      source = ../../../config/nvim;
      recursive = true;
    };
  };
}
