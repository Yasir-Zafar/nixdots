{
  programs.nixvim = {
    # Collection of various small independent plugins/modules
    plugins.mini = {
      enable = true;

      modules = {
        # around/inside textobjects: va) yinq ci'
        ai = {
          n_lines = 500;
        };

        # surround: saiw) sd' sr)'
        surround = {
          mappings = {
            add = "gsa";
            delete = "gsd";
            replace = "gsr";
            find = "gsf";
            find_left = "gsF";
            highlight = "gsh";
            update_n_lines = "gsn";
          };
        };

        # pairs = {}; # off: nvim-autopairs (plugins/autopairs.nix) does this

        # statusline
        statusline = {
          use_icons.__raw = "vim.g.have_nerd_font";
        };

      };
    };

    # statusline location as LINE:COLUMN
    extraConfigLua = ''
      require('mini.statusline').section_location = function()
        return '%2l:%-2v'
      end
    '';
  };
}
