{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [

    git
    wget
    curl

    htop
    wineWowPackages.waylandFull

  ];

}
