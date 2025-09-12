{ config, pkgs, ... }:
{
  fonts.packages = with pkgs; [
    jetbrains-mono
    inter
    roboto
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [ "Inter" ];
      sansSerif = [ "Inter" ];
      monospace = [ "JetBrains Mono"];
    };
  };
}
