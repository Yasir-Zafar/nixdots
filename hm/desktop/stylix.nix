{pkgs, ...}: {
  stylix = {
    enable = true;
    # adopt gradually: only the targets listed below are themed
    autoEnable = false;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";

    fonts = {
      monospace = {
        package = pkgs.jetbrains-mono;
        name = "JetBrains Mono";
      };
      sizes.terminal = 12;
    };

    targets = {
      ghostty.enable = true;
      bat.enable = true;
      fzf.enable = true;
      qt.enable = true;
    };
  };
}
