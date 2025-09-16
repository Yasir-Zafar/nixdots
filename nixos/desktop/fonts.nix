# nixos/desktop/fonts.nix
{
  config,
  pkgs,
  ...
}: {
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = ["Source Serif Pro" "DejaVu Serif"];
      sansSerif = ["Inter" "DejaVu Sans"];
      monospace = ["JetBrains Mono" "DejaVu Sans Mono"];
      emoji = ["Noto Color Emoji"];
    };
    # Better font rendering
    subpixel = {
      rgba = "rgb";
      lcdfilter = "default";
    };

    # Font hinting and anti-aliasing
    hinting = {
      enable = true;
      style = "slight";
    };
  };

  # Font packages
  fonts.packages = with pkgs; [
    # Programming fonts
    jetbrains-mono
    fira-code
    inconsolata
    atkinson-monolegible

    # System fonts
    inter
    roboto
    source-sans-pro
    source-serif-pro
    ubuntu_font_family

    # Serif fonts
    atkinson-hyperlegible
    dejavu_fonts
    liberation_ttf

    # Symbol/Icon fonts
    font-awesome
    material-icons
    material-design-icons

    # Variable fonts
    iosevka

    # Additional fonts
    liberation_ttf
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    noto-fonts-color-emoji
  ];

  # Install font utilities
  environment.systemPackages = with pkgs; [
    glxinfo
  ];
}
