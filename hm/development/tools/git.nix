# ============================================================================
# Git Configuration
# Location: hm/development/tools/git.nix
# ============================================================================
{pkgs, ...}: {
  # ==========================================================================
  # GIT-RELATED PACKAGES
  # ==========================================================================
  home.packages = with pkgs; [
    # ------------------------------------------------------------------------
    # Git Extensions
    # ------------------------------------------------------------------------
    git-lfs # Large File Storage support

    # ------------------------------------------------------------------------
    # Git TUI/GUI Tools
    # ------------------------------------------------------------------------
    gitui # Fast terminal UI for git
    lazygit # Simple terminal UI for git
    # tig # Alternative: Text-mode interface for git

    # ------------------------------------------------------------------------
    # GitHub Integration
    # ------------------------------------------------------------------------
    gh # GitHub CLI

    # ------------------------------------------------------------------------
    # Diff Tools
    # ------------------------------------------------------------------------
    delta # Syntax-highlighting pager for git
    difftastic # Structural diff tool
    # diff-so-fancy # Alternative: Readable diffs
  ];

  # ==========================================================================
  # GIT CONFIGURATION
  # ==========================================================================
  programs.git = {
    enable = true;

    # ------------------------------------------------------------------------
    # User Information
    # ------------------------------------------------------------------------
    settings = {
      user.name = "Yasir-Zafar";
      user.mail = "yasirzafar365@gmail.com";

      # ------------------------------------------------------------------------
      # Core Settings
      # ------------------------------------------------------------------------

      extraConfig = {
        # Initialize settings
        init = {
          defaultBranch = "main";
        };

        # Push settings
        push = {
          default = "simple"; # Push only current branch
          autoSetupRemote = true; # Auto-setup remote tracking
          followTags = true; # Push relevant tags
        };

        # Pull settings
        pull = {
          rebase = true; # Rebase instead of merge on pull
          ff = "only"; # Fast-forward only
        };

        # Core settings
        core = {
          editor = "nvim";
          autocrlf = "input"; # Convert CRLF to LF on commit
          pager = "delta"; # Use delta for diffs
          whitespace = "trailing-space,space-before-tab";
        };

        # Diff settings
        diff = {
          tool = "difftastic";
          colorMoved = "default"; # Highlight moved code
          algorithm = "histogram"; # Better diff algorithm
        };

        # Merge settings
        merge = {
          tool = "vimdiff";
          conflictstyle = "diff3"; # Show common ancestor
        };

        # Rebase settings
        rebase = {
          autoStash = true; # Auto-stash before rebase
          autoSquash = true; # Auto-squash fixup commits
        };

        # Fetch settings
        fetch = {
          prune = true; # Auto-prune deleted branches
          pruneTags = true; # Auto-prune deleted tags
        };

        # Status settings
        status = {
          showUntrackedFiles = "all";
          submoduleSummary = true;
        };

        # Color settings
        color = {
          ui = "auto";
          branch = "auto";
          diff = "auto";
          status = "auto";
        };

        # ------------------------------------------------------------------------
        # Delta Configuration (Syntax-Highlighted Diffs)
        # ------------------------------------------------------------------------
        interactive = {
          diffFilter = "delta --color-only";
        };

        delta = {
          navigate = true; # Use n/N to move between diff sections
          light = false; # Dark mode
          line-numbers = true; # Show line numbers
          side-by-side = false; # Linear view (set true for side-by-side)
          syntax-theme = "gruvbox-dark"; # Gruvbox theme

          # Features
          features = "decorations";

          # Plus/minus style
          plus-style = "syntax #003800";
          minus-style = "syntax #3f0001";

          # Additional styling
          file-style = "bold yellow ul";
          file-decoration-style = "none";
          hunk-header-decoration-style = "cyan box";
          hunk-header-line-number-style = "#067a00";
        };

        # Security & Performance
        # ------------------------------------------------------------------------
        credential = {
          helper = "cache --timeout=3600"; # Cache credentials for 1 hour
        };

        help = {
          autocorrect = "prompt"; # Suggest corrections for typos
        };
      };

      # ------------------------------------------------------------------------
      # Git Aliases
      # ------------------------------------------------------------------------
      aliases = {
        # Status shortcuts
        st = "status";
        s = "status -sb"; # Short status

        # Checkout shortcuts
        co = "checkout";
        cob = "checkout -b"; # Create and checkout branch

        # Branch shortcuts
        br = "branch";
        bra = "branch -a"; # Show all branches
        brd = "branch -d"; # Delete branch
        brD = "branch -D"; # Force delete branch

        # Commit shortcuts
        ci = "commit";
        cm = "commit -m";
        ca = "commit --amend";
        can = "commit --amend --no-edit";

        # Add shortcuts
        a = "add";
        aa = "add --all";
        ap = "add --patch"; # Interactive staging

        # Diff shortcuts
        df = "diff";
        dfc = "diff --cached";
        dft = "difftool";

        # Log shortcuts
        l = "log --oneline";
        lg = "log --oneline --graph --decorate --all";
        lp = "log --patch"; # Show diff in log
        last = "log -1 HEAD"; # Show last commit

        # Push/Pull shortcuts
        p = "push";
        pf = "push --force-with-lease"; # Safer force push
        pl = "pull";

        # Stash shortcuts
        stl = "stash list";
        stp = "stash pop";
        sta = "stash apply";
        std = "stash drop";

        # Reset shortcuts
        unstage = "reset HEAD --";
        undo = "reset --soft HEAD^"; # Undo last commit, keep changes

        # Utility aliases
        visual = "!gitk"; # Launch gitk
        aliases = "config --get-regexp alias"; # List all aliases

        # Show file history
        filelog = "log -u";

        # Find commits by message
        find = "log --pretty=\\\"format:%Cgreen%H %Cblue%s\\\" --name-status --grep";

        # Show ignored files
        ignored = "ls-files --others --ignored --exclude-standard";

        # Quick commit all changes
        qc = "!git add -A && git commit -m";

        # Show current branch
        current = "rev-parse --abbrev-ref HEAD";

        # Clean merged branches
        cleanup = "!git branch --merged | grep -v '\\*\\|main\\|master\\|develop' | xargs -n 1 git branch -d";
      };
    };

    # ------------------------------------------------------------------------
    # Git Ignore (Global)
    # ------------------------------------------------------------------------
    ignores = [
      # OS-specific
      ".DS_Store"
      "Thumbs.db"
      "desktop.ini"

      # Editor-specific
      ".vscode/"
      ".idea/"
      "*.swp"
      "*.swo"
      "*~"
      ".vim/"

      # Build artifacts
      "*.o"
      "*.so"
      "*.dylib"
      "*.dll"
      "*.class"
      "*.pyc"
      "__pycache__/"

      # Logs
      "*.log"
      "npm-debug.log*"

      # Dependencies
      "node_modules/"
      ".pnp/"
      ".pnp.js"

      # Environment
      ".env"
      ".env.local"

      # Misc
      "*.bak"
      "*.tmp"
      ".~lock.*"
    ];

    # ------------------------------------------------------------------------
    # Git LFS
    # ------------------------------------------------------------------------
    lfs = {
      enable = true;
    };
  };
}
# ============================================================================
# ADDITIONAL GIT CONFIGURATION TIPS
# ============================================================================
# 1. SSH Key Setup:
#    ssh-keygen -t ed25519 -C "yasirzafar365@gmail.com"
#    cat ~/.ssh/id_ed25519.pub  # Add to GitHub
#
# 2. GPG Signing (Optional):
#    extraConfig.commit.gpgsign = true;
#    extraConfig.user.signingkey = "YOUR_KEY_ID";
#
# 3. Custom Git Hooks:
#    Place in .git/hooks/ or use pre-commit framework
#
# 4. Git Worktrees:
#    git worktree add ../feature-branch feature-branch
#
# 5. Useful Git Commands:
#    git reflog                    # View reference logs
#    git bisect                    # Binary search for bugs
#    git blame -C -C -C file.txt   # Find code origins
# ============================================================================

