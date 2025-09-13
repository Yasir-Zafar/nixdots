# hm/development/tools/git.nix
{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "Yasir-Zafar"; # Replace with your name
    userEmail = "yasirzafar365@gmail.com"; # Replace with your email

    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      push = {
        default = "simple";
        autoSetupRemote = true;
      };
      pull = {
        rebase = true;
      };
      core = {
        editor = "nvim";
        autocrlf = "input";
      };
      diff = {
        tool = "vimdiff";
      };
      merge = {
        tool = "vimdiff";
      };
    };

    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      df = "diff";
      lg = "log --oneline --graph --decorate --all";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      visual = "!gitk";
    };
  };

  # Git-related packages
  home.packages = with pkgs; [
    # Git tools
    git-lfs
    gitui
    lazygit
    gh # GitHub CLI

    # Diff tools
    delta
    difftastic
  ];

  # Delta configuration for better git diffs
  programs.git.extraConfig.core.pager = "delta";
  programs.git.extraConfig.interactive.diffFilter = "delta --color-only";
  programs.git.extraConfig.delta = {
    navigate = true;
    light = false;
    line-numbers = true;
  };
}
