{lib,...}{
  programs.neovim = {
  enable = true;
  extraConfig = lib.fileContents ../config/nvim/init.lua;
};
}
