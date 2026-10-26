{pkgs, ...}: {
  home.packages = with pkgs; [
    papers
    foliate
    obsidian
    formiko
    gnome-text-editor
    gnome-decoder
    # gnome-frog # ocr: grab text from images (posthog broken in nixpkgs, 2026-10)
    # errands
    libreoffice
    qpdf
    # gnome-notes
    # thunderbird
    # zoom-us
  ];
}
