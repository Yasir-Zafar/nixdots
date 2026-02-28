# ============================================================================
# Development Tools Configuration
# Location: hm/development/tools/default.nix
# ============================================================================
{
  imports = [
    ./git.nix # Git configuration and aliases
    ./terminal.nix # Terminal tools and Zsh/Bash setup
    ./version-control.nix # Additional VCS tools (gh, glab, etc.)
    ./sql.nix # Database tools
    ./wireshark.nix
  ];
}
