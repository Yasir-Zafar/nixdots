# terminal workflow: history, multiplexer, git ui, file manager
{
  programs = {
    atuin = {
      enable = true;
      # keep up-arrow for normal history, atuin on ctrl+r
      flags = ["--disable-up-arrow"];
    };

    zellij = {
      enable = true;
      # start it by hand with `zellij`, not on every terminal
    };

    lazygit.enable = true; # `lg` alias lives in shell/aliases/git.nix

    # `spf`; built-in themes: https://superfile.dev/list/theme-list
    superfile = {
      enable = true;
      settings = {
        theme = "gruvbox"; # gruvbox dark medium, same as stylix
        ignore_missing_fields = true; # only overrides are set here, the rest stay default
      };
    };

    # yazi: faster terminal file manager with previews (images in ghostty, pdf, video);
    # `y` opens it and cds to wherever you quit. Colours from stylix.
    yazi = {
      enable = true;
      shellWrapperName = "y";
      settings.mgr = {
        show_hidden = false;
        sort_dir_first = true;
      };
    };
  };
}
