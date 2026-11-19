{
  programs.nixvim.plugins = {
    # `friendly-snippets` contains a variety of premade snippets (blink loads them itself,
    # and expands them with Neovim's built-in snippet engine)
    #    https://github.com/rafamadriz/friendly-snippets
    friendly-snippets.enable = true;
    lazydev.enable = true; # Lua completion for the Neovim API (source below)

    # Autocompletion. Replaced nvim-cmp: one plugin, no separate source plugins or snippet
    # engine. Brackets after a function are added by blink itself (accept.auto_brackets).
    # See `:help blink-cmp`
    # https://nix-community.github.io/nixvim/plugins/blink-cmp/index.html
    blink-cmp = {
      enable = true;

      # nixvim only does this for the retired `plugins.lsp`; lsp.nix does it for `lsp.servers`
      setupLspCapabilities = false;

      settings = {
        # preset "default": <C-n>/<C-p> select, <C-y> accept, <C-Space> menu / docs,
        # <C-e> hide, <C-b>/<C-f> scroll docs, <Tab>/<S-Tab> snippet jump, <C-k> signature
        keymap = {
          preset = "default";
          # the keys the old nvim-cmp setup used for jumping around in a snippet
          "<C-l>" = ["snippet_forward" "fallback"];
          "<C-h>" = ["snippet_backward" "fallback"];
        };

        completion.documentation = {
          auto_show = true;
          auto_show_delay_ms = 200;
        };

        # function signature while typing the arguments
        signature.enabled = true;

        sources = {
          # lsp, path, snippets and buffer are the default; lazydev only makes sense in Lua
          per_filetype.lua = ["lazydev" "lsp" "path" "snippets" "buffer"];
          providers.lazydev = {
            name = "LazyDev";
            module = "lazydev.integrations.blink";
            score_offset = 100; # above the LuaLS completions
          };
        };
      };
    };
  };
}
