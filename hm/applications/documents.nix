{pkgs, ...}: {
  home.packages = with pkgs; [
    papers
    foliate
    obsidian
    gnome-text-editor
    gnome-decoder
    qpdf
    # libreoffice
    # gnome-notes
    # thunderbird
    # zoom-us
  ];
}
