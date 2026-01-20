# ============================================================================
# Version Control Tools Configuration
# Location: hm/development/tools/version-control.nix
# ============================================================================
{pkgs, ...}: {
  # ==========================================================================
  # VERSION CONTROL PACKAGES
  # ==========================================================================
  home.packages = with pkgs; [
    # ------------------------------------------------------------------------
    # Git Utilities
    # ------------------------------------------------------------------------
    git-filter-repo # Fast tool for rewriting git history
    git-crypt # Transparent file encryption in git
    git-secrets # Prevents committing secrets
    git-absorb # Automatically fixup commits

    # ------------------------------------------------------------------------
    # Platform CLIs
    # ------------------------------------------------------------------------
    gh # GitHub CLI (configured below)
    # gitea # Alternative: Gitea CLI

    # ------------------------------------------------------------------------
    # Other Version Control Systems
    # ------------------------------------------------------------------------
    # mercurial # Hg version control
    # subversion # SVN (legacy projects)
    # fossil # Distributed VCS with built-in wiki and bug tracker
  ];

  # ==========================================================================
  # GITHUB CLI CONFIGURATION
  # ==========================================================================
  programs.gh = {
    enable = true;

    settings = {
      # Git protocol preference
      git_protocol = "ssh"; # Use SSH instead of HTTPS

      # Editor for GitHub operations
      editor = "nvim";

      # Prompt behavior
      prompt = "enabled";

      # Pager for output
      pager = "delta";

      # Browser for opening web pages
      # browser = "zen-beta";

      # Aliases for gh commands
      aliases = {
        # Repository shortcuts
        co = "repo clone";
        pv = "pr view";
        pc = "pr create";
        iv = "issue view";
        ic = "issue create";

        # Quick PR creation
        prc = "pr create --fill";

        # View PR in browser
        prw = "pr view --web";

        # List my PRs
        prme = "pr list --author @me";

        # List my issues
        isme = "issue list --assignee @me";
      };
    };
  };
}
# ============================================================================
# VERSION CONTROL TOOL USAGE
# ============================================================================
# GitHub CLI (gh):
#   gh repo clone owner/repo          # Clone repository
#   gh pr create                      # Create pull request
#   gh pr list                        # List pull requests
#   gh issue create                   # Create issue
#   gh workflow run                   # Trigger GitHub Action
#
# GitLab CLI (glab):
#   glab repo clone owner/repo        # Clone repository
#   glab mr create                    # Create merge request
#   glab ci view                      # View CI pipeline
#
# Git Filter Repo:
#   git filter-repo --path dir/       # Keep only specific directory
#   git filter-repo --strip-blobs-bigger-than 10M  # Remove large files
#
# Git Crypt:
#   git-crypt init                    # Initialize encryption
#   git-crypt add-gpg-user KEY_ID     # Add GPG key
#
# Git Secrets:
#   git secrets --scan                # Scan for secrets
#   git secrets --install             # Install git hooks
# ============================================================================

