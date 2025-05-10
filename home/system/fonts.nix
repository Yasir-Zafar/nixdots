# home/system/fonts.nix
{ config, lib, pkgs, ... }:

{
  # Font configuration
  fonts.fontconfig.enable = true;
  
  home.packages = with pkgs; [
    # Sans-serif fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    inter
    liberation_ttf
    roboto
    open-sans
    
    # Serif fonts
    noto-fonts-serif
    dejavu_fonts
    
    # Monospace fonts
    jetbrains-mono
    fira-code
    fira-code-symbols
    hack-font
    iosevka
    
    # Nerd Fonts
    (nerdfonts.override { 
      fonts = [ 
        "JetBrainsMono" 
        "FiraCode" 
        "Hack" 
        "Iosevka"
      ]; 
    })
    
    # Icon fonts
    font-awesome
    material-design-icons
    material-icons
    
    # CJK fonts
    wqy_microhei
    wqy_zenhei
    
    # Arabic fonts
    scheherazade
    
    # Other language support
    culmus # Hebrew
    lohit-fonts.tamil
    lohit-fonts.devanagari
    
    # Symbol fonts
    symbola
  ];
}
