{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [

    git
    wget
    curl

    htop
    powertop
    wineWowPackages.waylandFull

  ];

}
