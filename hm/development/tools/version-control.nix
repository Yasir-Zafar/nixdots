{pkgs, ...}: {
  home.packages = with pkgs; [
    git-filter-repo
    git-crypt
    git-secrets
    git-absorb
    gh
  ];

  programs.gh = {
    enable = true;

    settings = {
      git_protocol = "ssh";
      editor = "nvim";
      prompt = "enabled";
      pager = "delta";

      aliases = {
        co = "repo clone";
        pv = "pr view";
        pc = "pr create";
        iv = "issue view";
        ic = "issue create";
        prc = "pr create --fill";
        prw = "pr view --web";
        prme = "pr list --author @me";
        isme = "issue list --assignee @me";
      };
    };
  };
}
