{ pkgs, ... }:
{

  home.packages = with pkgs; [

    libnotify
    fd
    ripgrep
    fzf
    ffmpeg
    unzip
    (texlive.combine { inherit (texlive) scheme-full wrapfig titling titlesec fontspec; })

    libnotify
    mpc-cli
    yt-dlp
    grim
    slurp
    wl-clipboard

    p7zip

    brillo
    wbg
    mpd
    mpv
    imv
    swayidle
    waybar
    eww-wayland
    wofi

    llvmPackages_17.libcxxClang
    clang-tools_17
    libtool
    gdb
    cmake
    gnumake

    rustup
    
    html-tidy
    nodejs

    nasm

    jdk

    gtk-engine-murrine
    gtk_engines
    gnome.nautilus
    gnome-solanum
    evince
    transmission-gtk

    vim
    neovim-unwrapped
    firefox-wayland
    libreoffice-fresh
    (python311.withPackages (ps: with ps; [
      pip
      adblock
      pynvim
      flake8
      black
    ]))

  ];

}
