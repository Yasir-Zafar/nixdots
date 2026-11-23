{
  programs.nixvim.plugins = {
    # friendly-snippets, expanded by Neovim's built-in engine
    friendly-snippets.enable = true;
    lazydev.enable = true; # Lua completion for the Neovim API (source below)

    # completion; also adds () after functions (accept.auto_brackets)
    blink-cmp = {
      enable = true;

      # nixvim only does this for the retired `plugins.lsp`; lsp.nix does it for `lsp.servers`
      setupLspCapabilities = false;

      settings = {
        # preset default: <C-n>/<C-p> select, <C-y> accept, <C-Space> menu, <C-e> hide
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
