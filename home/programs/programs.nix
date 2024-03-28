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

    # libnotify
    # mpc-cli
    # yt-dlp
    # ffmpeg
    # grim
    # slurp
    # wl-clipboard

    # brillo
    # wbg
    # mpd
    # mpv
    # imv
    # swayidle
    # waybar
    # wofi
    # libnotify

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
    discord
    libreoffice-fresh
    syncthing
    calibre
    qtcreator
    inkscape
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
