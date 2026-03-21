{pkgs, ...}: {
  home.packages = with pkgs; [
    git-lfs
    lazygit
    delta
    difftastic
  ];

  programs.git = {
    enable = true;

    settings = {
      user.name = "Yasir-Zafar";
      user.mail = "yasirzafar365@gmail.com";

      extraConfig = {
        init.defaultBranch = "main";

        push = {
          default = "simple";
          autoSetupRemote = true;
          followTags = true;
        };

        pull = {
          rebase = true;
        };

        core = {
          editor = "nvim";
          autocrlf = "input";
          pager = "delta";
          whitespace = "trailing-space,space-before-tab";
        };

        diff = {
          tool = "difftastic";
          colorMoved = "default";
          algorithm = "histogram";
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

        interactive.diffFilter = "delta --color-only";

        delta = {
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

        credential.helper = "cache --timeout=3600";
        help.autocorrect = "prompt";
      };

      aliases = {
        st = "status";
        s = "status -sb";
        co = "checkout";
        cob = "checkout -b";
        br = "branch";
        bra = "branch -a";
        brd = "branch -d";
        brD = "branch -D";
        ci = "commit";
        cm = "commit -m";
        ca = "commit --amend";
        can = "commit --amend --no-edit";
        a = "add";
        aa = "add --all";
        ap = "add --patch";
        df = "diff";
        dfc = "diff --cached";
        dft = "difftool";
        l = "log --oneline";
        lg = "log --oneline --graph --decorate --all";
        lp = "log --patch";
        last = "log -1 HEAD";
        p = "push";
        pf = "push --force-with-lease";
        pl = "pull";
        stl = "stash list";
        stp = "stash pop";
        sta = "stash apply";
        std = "stash drop";
        unstage = "reset HEAD --";
        undo = "reset --soft HEAD^";
        aliases = "config --get-regexp alias";
        filelog = "log -u";
        ignored = "ls-files --others --ignored --exclude-standard";
        qc = "!git add -A && git commit -m";
        current = "rev-parse --abbrev-ref HEAD";
        cleanup = "!git branch --merged | grep -v '\\*\\|main\\|master\\|develop' | xargs -n 1 git branch -d";
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
      ".vim/"
      "*.o"
      "*.so"
      "*.dylib"
      "*.dll"
      "*.class"
      "*.pyc"
      "__pycache__/"
      "*.log"
      "npm-debug.log*"
      "node_modules/"
      ".pnp/"
      ".pnp.js"
      ".env"
      ".env.local"
      "*.bak"
      "*.tmp"
      ".~lock.*"
    ];

    lfs.enable = true;
  };
}
