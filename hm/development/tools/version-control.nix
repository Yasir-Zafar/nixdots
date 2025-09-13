# hm/development/tools/version-control.nix
{
  config,
  pkgs,
  ...
}: {
  # Additional version control tools
  home.packages = with pkgs; [
    # Git utilities
    git-filter-repo
    git-crypt
    git-secrets

    # GitHub/GitLab tools
    gh # GitHub CLI
    glab # GitLab CLI

    # Other VCS
    mercurial # Hg
    subversion # SVN (if needed)
  ];

  # GitHub CLI configuration
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      editor = "nvim";
      prompt = "enabled";
      pager = "delta";
    };
  };
}
