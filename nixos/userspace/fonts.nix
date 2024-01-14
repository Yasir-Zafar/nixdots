{ pkgs, ... }:{

  fonts = {

    packages = with pkgs; [

      nerdfonts
      corefonts
      jetbrains-mono
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji

    ];

  };

}
