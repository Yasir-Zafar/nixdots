{ pkgs, ... }:
{

  home.packages = with pkgs; [

    fd
    ripgrep

    lf
    htop
    mpc-cli
    ffmpeg
    yt-dlp
    libnotify
    swayidle
    grim
    ffmpeg
    neofetch
    grim
    slurp
    wl-clipboard

    zip
    unzip
    p7zip

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
    neovim-unwrapped

    pavucontrol
    firefox-wayland
    qutebrowser
    thunderbird

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
    font-manager

    gimp
    libreoffice-fresh
    calibre
    whatsapp-for-linux
    steam
    syncthing
    (pkgs.discord.override {
      withVencord = true;
    })

    (python311.withPackages (ps: with ps; [
      pip
      adblock
      pynvim
      flake8
    ]))

  ];

}
