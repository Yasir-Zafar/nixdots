{
  programs = {
    git = {
      enable = true;
      userName = "Yasir-Zafar";
      userEmail = "142168543+Yasir-Zafar@users.noreply.github.com";

      extraConfig = {
        color = {
          ui = "auto";
        };

        pull = {
          rebase = false;
        };

        init = {
          defaultBranch = "main";
        };
      };
    };
  };
}
