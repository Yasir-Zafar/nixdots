{pkgs, ...}: {
  stylix = {
    enable = true;
    # adopt gradually: only the targets listed below are themed
    autoEnable = false;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        # the "Mono" variant keeps icons single-width, which terminals want
        name = "JetBrainsMono Nerd Font Mono";
      };
      # same default sans as the system (nix/desktop/fonts.nix), so qt and gtk match
      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };
      sizes = {
        terminal = 12;
        applications = 11;
      };
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    targets = {
      ghostty.enable = true;
      bat.enable = true;
      fzf.enable = true;
      fish.enable = true;
      lazygit.enable = true;
      zellij.enable = true;
    };
  };
}
