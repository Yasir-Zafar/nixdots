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

    pavucontrol
    firefox-wayland
    qutebrowser
    thunderbird

    gnome.nautilus
    gnome.sushi
    gnome.gnome-calculator
    gnome.gnome-boxes
    gnome-solanum
    evince
    bottles
    #transmission-gtk
    #font-manager

    #gimp
    libreoffice
    calibre
    whatsapp-for-linux
    steam
    syncthing
    (pkgs.discord.override {
      # remove any overrides that you don't want
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
