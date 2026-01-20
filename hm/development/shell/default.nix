# ============================================================================
# Shell Configuration
# Location: hm/development/shell/default.nix
# ============================================================================
{
  imports = [
    ./bash.nix # Bash shell configuration
    ./aliases.nix # Shell aliases and shortcuts
    ./enviroment.nix # Environment variables
    # ./zsh.nix # Uncomment if using Zsh
    # ./starship.nix # Uncomment for Starship prompt
  ];
}
