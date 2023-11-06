{ pkgs, ... }:
{

  home.packages = with pkgs; [

    fd
    ripgrep
    html-tidy
    fzf

    lf
    htop
    neofetch
    libnotify
    mpc-cli
    ffmpeg
    yt-dlp
    swayidle
    grim
    slurp
    wl-clipboard
    android-tools

    zip
    unzip
    p7zip
    isync
    ledger

    brillo
    wbg
    mpd
    mpv
    imv

    waybar
    wofi

    ccls
    llvmPackages_16.libcxxClang
    clang-tools_16
    libtool
    nodejs
    nasm
    neovim-unwrapped
    (texlive.combine { inherit (texlive) scheme-full wrapfig titling titlesec fontspec; })

    gtk-engine-murrine
    gtk_engines
    gnome.gnome-themes-extra
    gnome.nautilus
    gnome.sushi
    gnome.gnome-calculator
    gnome.gnome-boxes
    gnome-solanum
    evince
    bottles
    transmission-gtk
    octaveFull
    font-manager

    pavucontrol
    firefox-wayland
    qutebrowser
    thunderbird
    gimp
    libreoffice-fresh
    calibre
    whatsapp-for-linux
    steam
    syncthing
    dbeaver
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
