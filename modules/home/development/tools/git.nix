{pkgs, ...}: {
  home.packages = with pkgs; [
    lazygit
    difftastic
    git-lfs
    git-filter-repo
    git-crypt
    git-absorb
  ];

  programs = {
    git = {
      enable = true;

      settings = {
        # `settings` is the gitconfig itself: top-level keys become [sections]
        user.name = "Yasir-Zafar";
        user.email = "yasirzafar365@gmail.com";

        init.defaultBranch = "main";

        push = {
          default = "simple";
          autoSetupRemote = true;
          followTags = true;
        };

        pull.rebase = true;

        core = {
          editor = "nvim";
          autocrlf = "input";
          # pager comes from programs.delta below
          whitespace = "trailing-space,space-before-tab";
        };

        diff = {
          tool = "difftastic";
          colorMoved = "default";
          algorithm = "histogram";
        };

        # `git difftool` -> difftastic (git allows only one pager integration: delta)
        difftool = {
          prompt = false;
          difftastic.cmd = ''difft "$LOCAL" "$REMOTE"'';
        };

        merge = {
          tool = "vimdiff";
          conflictstyle = "diff3";
        };

        rebase = {
          autoStash = true;
          autoSquash = true;
        };

        fetch = {
          prune = true;
          pruneTags = true;
        };

        status = {
          showUntrackedFiles = "all";
          submoduleSummary = true;
        };

        color.ui = "auto";

        credential.helper = "cache --timeout=3600";
        help.autocorrect = "prompt";

        alias = {
          s = "status -sb";
          co = "checkout";
          cob = "checkout -b";
          cm = "commit -m";
          ca = "commit --amend";
          can = "commit --amend --no-edit";
          a = "add";
          aa = "add --all";
          ap = "add --patch";
          dfc = "diff --cached";
          dft = "difftool";
          l = "log --oneline";
          lg = "log --oneline --graph --decorate --all";
          lp = "log --patch";
          last = "log -1 HEAD";
          pf = "push --force-with-lease";
          stl = "stash list";
          stp = "stash pop";
          unstage = "reset HEAD --";
          undo = "reset --soft HEAD^";
          qc = "!git add -A && git commit -m";
          current = "rev-parse --abbrev-ref HEAD";
          cleanup = "!git branch --merged | grep -v '\\*\\|main\\|master\\|develop' | xargs -n 1 git branch -d";
          ignored = "ls-files --others --ignored --exclude-standard";
        };
      };

      ignores = [
        ".DS_Store"
        "Thumbs.db"
        "desktop.ini"
        ".vscode/"
        ".idea/"
        "*.swp"
        "*.swo"
        "*~"
        "*.o"
        "*.so"
        "*.class"
        "*.pyc"
        "__pycache__/"
        "*.log"
        "npm-debug.log*"
        "node_modules/"
        ".env"
        ".env.local"
        "*.bak"
        "*.tmp"
        ".~lock.*"
      ];

      lfs.enable = true;
    };

    # sets core.pager and interactive.diffFilter for git
    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        navigate = true;
        light = false;
        line-numbers = true;
        side-by-side = false;
        syntax-theme = "gruvbox-dark";
        features = "decorations";
        plus-style = "syntax #003800";
        minus-style = "syntax #3f0001";
        file-style = "bold yellow ul";
        file-decoration-style = "none";
        hunk-header-decoration-style = "cyan box";
        hunk-header-line-number-style = "#067a00";
      };
    };

    gh = {
      enable = true;

      settings = {
        git_protocol = "ssh";
        editor = "nvim";
        prompt = "enabled";
        pager = "delta";

        aliases = {
          co = "repo clone";
          prc = "pr create --fill";
          prw = "pr view --web";
          prme = "pr list --author @me";
          isme = "issue list --assignee @me";
        };
      };
    };
  };
}
