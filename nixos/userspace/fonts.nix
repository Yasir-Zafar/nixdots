{ pkgs, ... }:{

  fonts = {

    packages = with pkgs; [

      nerdfonts
      corefonts
      noto-fonts
      jetbrains-mono
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji

    ];

    fontconfig = {

      hinting = {
        style = "full"; # no difference
        autohint = true; # no difference
      };

      subpixel = {
      
        rgba = "rgb";
        lcdfilter = "default"; # no difference

      };

    };

  };

}
