{ config, pkgs, ... }:
{
  fonts.packages = with pkgs; [
    jetbrains-mono
    inter
    robotto
    noto-fonts
    noto-fonts-cjk
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
