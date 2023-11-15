{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [

    xdg-desktop-portal-gtk
 
    fd
    ripgrep
    fzf

    git
    wget
    curl

    lf
    htop
    neofetch
    powertop

  ];

}
