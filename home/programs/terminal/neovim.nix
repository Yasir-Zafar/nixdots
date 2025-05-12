{ config, lib, pkgs, ... }:

let
  # Import the nixCats module
  nixCats = import ../../../config/nvim;
in
{
  # Enable nixCats Home Manager module
  imports = [
    nixCats.homeModule  # Import the nixCats home module
  ];

  # Enable the package and module configuration in Home Manager
  nixCats.enable = true;
  nixCats.packageNames = [ "myHomeModuleNvim" ];  # Replace with actual package names if different
  nixCats.luaPath = ./.;  # Set the Lua path or any other required paths

  # You can also customize further by adding other options in this file
}

