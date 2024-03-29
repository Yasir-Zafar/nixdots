{ pkgs, ... }:
{

  home.packages = with pkgs; [

    fd
    ripgrep
    fzf
    semgrep
    unzip
    unrar
    p7zip
    neofetch
    (texlive.combine { inherit (texlive) scheme-full wrapfig titling titlesec fontspec; })

    llvmPackages_17.libcxxClang
    clang-tools_17
    libtool
    gdb
    cmake
    gnumake
    mono

    rustup
    nodejs
    jdk
    nasm

    gtk-engine-murrine
    gtk_engines
    gnome.nautilus
    gnome-solanum

    neovim-unwrapped
    firefox-wayland
    discord
    libreoffice-fresh
    syncthing
    calibre
    qtcreator
    wineWowPackages.waylandFull
    (python311.withPackages (ps: with ps; [
      pip
      adblock
      pynvim
      flake8
      black
    ]))

  ];

}
