{pkgs, ...}: {
  fonts.fontconfig = {
    enable = true;

    defaultFonts = {
      serif = ["Source Serif Pro" "DejaVu Serif"];
      sansSerif = ["Inter" "DejaVu Sans"];
      monospace = ["JetBrains Mono" "DejaVu Sans Mono"];
      emoji = ["Noto Color Emoji"];
    };

    subpixel = {
      rgba = "rgb";
      lcdfilter = "default";
    };

    hinting = {
      enable = true;
      style = "slight";
    };
  };

  fonts.packages = with pkgs; [
    jetbrains-mono
    iosevka
    atkinson-monolegible

    inter
    roboto
    source-sans-pro
    source-serif-pro
    ubuntu-classic
    atkinson-hyperlegible

    dejavu_fonts
    liberation_ttf

    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji

    nerd-fonts.symbols-only
    font-awesome
    material-design-icons
  ];
}
