{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [

    xdg-desktop-portal-gtk
 
    git
    wget
    curl
    powertop

    ccls
    llvmPackages_16.libcxxClang
    clang-tools_16
    gnumake
    cmake
    jdk17

  ];

}
