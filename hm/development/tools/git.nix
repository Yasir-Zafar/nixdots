# hm/development/tools/git.nix
{pkgs, ...}: {
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

  programs = {
    git = {
      enable = true;

      settings = {
        user.name = "Yasir-Zafar"; # Replace with your name
        user.mail = "yasirzafar365@gmail.com"; # Replace with your email

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

        # Delta configuration for better git diffs
        core.pager = "delta";
        interactive.diffFilter = "delta --color-only";
        delta = {
          navigate = true;
          light = false;
          line-numbers = true;
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
    };
  };
}
