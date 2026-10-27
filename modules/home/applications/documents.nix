{pkgs, ...}: {
  home.packages = with pkgs; [
    papers
    foliate
    (obsidian.override {electron = electron_42;}) # electron 43.8.3 breaks renderer (webFrame errors), 2026-10
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
