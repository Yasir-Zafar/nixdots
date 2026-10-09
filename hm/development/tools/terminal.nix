# terminal workflow: history, multiplexer, git ui, file manager
{pkgs, ...}: {
  programs.atuin = {
    enable = true;
    # keep up-arrow for normal history, atuin on ctrl+r
    flags = ["--disable-up-arrow"];
  };

  programs.zellij = {
    enable = true;
    # start it by hand with `zellij`, not on every terminal
  };

  programs.lazygit.enable = true; # `lg` alias lives in shell/aliases/git.nix

  home.packages = [pkgs.superfile]; # `spf`
}
