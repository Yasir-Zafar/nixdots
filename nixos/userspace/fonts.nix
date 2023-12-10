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
      "${pkgs.fetchFromGitHub {
        owner = "addy-dclxvi";
        repo = "bitmap-font-collections";
        rev = "8ad8cfd";
        sha256 = "H3EmC+7BBQfGP0xGinBrW6GqisyarSAErsPIRHd7k48=";
      }}/bitmap"

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

      allowBitmaps = true;

    };

  };

}
