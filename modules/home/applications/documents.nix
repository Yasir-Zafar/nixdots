{pkgs, ...}: {
  home.packages = with pkgs; [
    papers
    foliate
    obsidian
    formiko
    gnome-text-editor
    gnome-decoder
    gnome-frog # ocr: grab text from images
    errands
    libreoffice
    qpdf
    # gnome-notes
    # thunderbird
    # zoom-us
  ];
}
