{ config, lib, pkgs, ... }:

{
  # Communication apps
  home.packages = with pkgs; [
    # Messaging
    vesktop
    
    # Email
    #thunderbird
    
    # Video conferencing
    #zoom-us
  ];
}
