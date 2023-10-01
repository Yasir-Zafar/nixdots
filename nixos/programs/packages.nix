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
    libtool
    nodejs
    python3

    gtk-engine-murrine
    gtk_engines
    gnome.gnome-themes-extra

    neovim-unwrapped

  ];

}
