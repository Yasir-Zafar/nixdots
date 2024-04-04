{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wget
    curl

    fd
    ripgrep
    fzf
    semgrep
    unzip
    unrar
    p7zip
    neofetch
    htop
    cava

    wineWowPackages.waylandFull
    mono
    jdk17
    nasm

    gtk-engine-murrine
    gtk_engines
  ];
}
