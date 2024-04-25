{ pkgs, ... }: {
  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    xdg-utils

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

    rustup
    nodejs
    nixfmt-rfc-style
    statix
    deadnix

    gnome.nautilus
    gnome-solanum
    evince
    transmission-gtk

    firefox-wayland
    thunderbird
    vscode
    pavucontrol
    gimp
    discord
    libreoffice-fresh
    syncthing
    calibre
    qtcreator
    qbittorrent
    winetricks
    wineWowPackages.waylandFull

    (texlive.combine { inherit (texlive) scheme-full wrapfig titling titlesec fontspec; })
    (python311.withPackages (ps:
      with ps; [
        pip
        adblock
        pynvim
        flake8
        black
      ]))
  ];
}
