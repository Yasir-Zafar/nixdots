{ pkgs, ... }:
{

  home.packages = with pkgs; [

    libnotify
    fd
    ripgrep
    fzf
    semgrep
    unzip
    unrar
    p7zip
    (texlive.combine { inherit (texlive) scheme-full wrapfig titling titlesec fontspec; })

    libnotify
    mpc-cli
    yt-dlp
    ffmpeg
    grim
    slurp
    wl-clipboard

    brillo
    wbg
    mpd
    mpv
    imv
    swayidle
    waybar
    wofi

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
    transmission-gtk

    neovim-unwrapped
    firefox-wayland
    pavucontrol
    libreoffice-fresh
    syncthing
    calibre
    gimp
    zoom-us
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
