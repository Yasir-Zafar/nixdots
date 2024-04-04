{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      nerdfonts
      corefonts
      jetbrains-mono
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      atkinson-hyperlegible
    ];
  };
}
