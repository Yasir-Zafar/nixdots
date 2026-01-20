# ============================================================================
# Development Configuration
# Location: hm/development/default.nix
# ============================================================================
{
  imports = [
    # ========================================================================
    # CODE EDITORS & IDEs
    # ========================================================================
    # Location: ./editors/
    # Contains: VSCode, Cursor, JetBrains, Neovim configurations
    ./editors

    # ========================================================================
    # PROGRAMMING LANGUAGES
    # ========================================================================
    # Location: ./languages/
    # Contains: Java, JavaScript/Node.js, Python environments
    # Each language has its own file with:
    # - Runtime/compiler
    # - Build tools and package managers
    # - Development tools (linters, formatters)
    # - Environment variables
    # - Configuration files
    ./languages

    # ========================================================================
    # DEVELOPMENT TOOLS
    # ========================================================================
    # Location: ./tools/
    # Contains:
    # - git.nix: Git configuration, delta, difftastic, aliases
    # - terminal.nix: Zsh, Bash, modern CLI tools, Starship
    # - version-control.nix: GitHub CLI, GitLab CLI, git utilities
    # - sql.nix: Database tools (SQLite, PostgreSQL, MySQL)
    ./tools

    # ========================================================================
    # SHELL CONFIGURATION
    # ========================================================================
    # Location: ./shell/
    # Contains:
    # - bash.nix: Bash shell configuration
    # - aliases.nix: Shell aliases and shortcuts
    # - environment.nix: Environment variables
    # Note: Shell config is also in ./tools/terminal.nix
    # Consider consolidating or choosing one location
    ./shell
  ];
}
