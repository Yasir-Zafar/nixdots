{pkgs, ...}: {
  home.packages = with pkgs; [
    papers
    foliate
    obsidian
    formiko
    gnome-text-editor
    gnome-decoder
    gnome-frog # ocr: grab text from images
    # errands # broken in nixpkgs; restore on a later update
    libreoffice
    qpdf
    # gnome-notes
    # thunderbird
    # zoom-us
  ];
}
