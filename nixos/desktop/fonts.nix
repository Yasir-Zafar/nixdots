# nixos/desktop/fonts.nix
{
  config,
  pkgs,
  ...
}: {
  # Font packages
  fonts.packages = with pkgs; [
    # Programming fonts
    (nerdfonts.override {fonts = ["FiraCode" "Meslo"];})

    # System fonts
    jetbrains-mono
    inter
    roboto
    source-sans-pro
    source-serif-pro

    # Additional fonts
    liberation_ttf
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = ["Source Serif Pro" "DejaVu Serif"];
      sansSerif = ["Inter" "DejaVu Sans"];
      monospace = ["JetBrains Mono" "DejaVu Sans Mono"];
    };
  };
}
