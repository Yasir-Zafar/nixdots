{ pkgs, ... }:
{

  home.packages = with pkgs; [

    libnotify
    mpc-cli
    ffmpeg
    yt-dlp
    swayidle
    grim
    slurp
    wl-clipboard
    (texlive.combine { inherit (texlive) scheme-full wrapfig titling titlesec fontspec; })

    zip
    unzip
    p7zip
    rar

    brillo
    wbg
    mpd
    mpv
    imv

    waybar
    wofi

    #ccls
    llvmPackages_16.libcxxClang
    clang-tools_16
    libtool
    gdb
    cmake

    rustup
    
    html-tidy
    nodejs

    nasm

    jdk
    maven
    gradle

    neovim-unwrapped
    android-studio

    gtk-engine-murrine
    gtk_engines
    gnome.gnome-themes-extra
    gnome.nautilus
    gnome.sushi
    gnome.gnome-calculator
    gnome.gnome-boxes
    gnome-solanum
    evince

    pavucontrol
    firefox-wayland
    qutebrowser
    thunderbird
    gimp
    libreoffice-fresh
    calibre
    syncthing
    obs-studio
    android-tools
    (pkgs.discord.override {
      withVencord = true;
    })

    (python311.withPackages (ps: with ps; [
      pip
      adblock
      pynvim
      flake8
      black
    ]))

  ];

}
