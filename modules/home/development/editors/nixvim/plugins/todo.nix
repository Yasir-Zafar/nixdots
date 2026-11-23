{
  programs.nixvim = {
    # highlight TODO/NOTE in comments
    plugins.todo-comments = {
      enable = true;
      settings = {
        signs = true;
      };
    };
  };
}
