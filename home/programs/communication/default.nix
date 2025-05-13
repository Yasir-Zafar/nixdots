{ pkgs, ... }:

{
  # Communication apps
  home.packages = with pkgs; [
    # Messaging
    vesktop

    # Video conferencing
    #zoom-us
  ];
}
