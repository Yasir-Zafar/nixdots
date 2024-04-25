{ pkgs, ... }: {
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

    jdk17
    nasm

    gtk-engine-murrine
    gtk_engines
  ];
}
