{
  programs.nixvim = {
    # pairs only; the "(" after a completed function comes from blink-cmp (accept.auto_brackets)
    plugins.nvim-autopairs = {
      enable = true;
    };
  };
}
