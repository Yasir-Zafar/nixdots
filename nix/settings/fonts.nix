# settings/fonts.nix
{ pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;

    # Enable better font rendering
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "DejaVu Serif" "Noto Serif" ];
        sansSerif = [ "Inter" "Noto Sans" ];
        monospace = [ "JetBrainsMono Nerd Font" "Noto Sans Mono" ];
        emoji = [ "Noto Color Emoji" ];
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

    # Install fonts
    packages = with pkgs; [
      # Sans-serif fonts
      inter
      noto-fonts
      roboto
      ubuntu_font_family
      open-sans

      # Serif fonts
      atkinson-hyperlegible
      dejavu_fonts
      liberation_ttf

      # Monospace fonts
      jetbrains-mono
      fira-code
      fira-code-symbols
      hack-font
      inconsolata
      victor-mono
      atkinson-monolegible

      # Symbol/Icon fonts
      font-awesome
      material-icons
      material-design-icons

      # CJK fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif

      # Emoji fonts
      noto-fonts-emoji
      noto-fonts-color-emoji

      # Programming ligature fonts
      hasklig

      # Variable fonts
      iosevka

      # Special purpose
      unifont # Fallback font
    ];
  };

  # Install font utilities
  environment.systemPackages = with pkgs; [
    fontpreview
    glxinfo
    font-manager
  ];
}
