# terminal workflow: history, multiplexer, git ui, file manager
{pkgs, ...}: {
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

    # yazi: faster terminal file manager with previews (images in ghostty, pdf, video);
    # `y` opens it and cds to wherever you quit. Colours and icons come from stylix
    # (gruvbox-dark-medium); the rest of the look is added here: rounded full border,
    # git status next to files, size + mtime column, a wider preview pane.
    yazi = {
      enable = true;
      shellWrapperName = "y";
      plugins = {
        inherit (pkgs.yaziPlugins) full-border git;
      };
      initLua = ''
        require("full-border"):setup { type = ui.Border.ROUNDED }
        require("git"):setup()
      '';
      # square ends on the hovered row instead of the default rounded pill
      theme.indicator.padding = {
        open = "▐";
        close = "▌";
      };
      settings = {
        mgr = {
          show_hidden = false;
          sort_dir_first = true;
          ratio = [1 3 4]; # parent / current / preview
          linemode = "size";
        };
        plugin.prepend_fetchers = [
          {
            group = "git";
            url = "*";
            run = "git";
          }
          {
            group = "git";
            url = "*/";
            run = "git";
          }
        ];
      };
    };
  };
}
