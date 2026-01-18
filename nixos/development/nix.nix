# nixos/development/nix.nix
# Nix development and configuration tools
{pkgs, ...}: {
  # ============================================================================
  # Nix Development Tools
  # ============================================================================
  environment.systemPackages = with pkgs; [
    # Linting & Analysis
    statix # Linter for Nix code (finds anti-patterns)
    deadnix # Find and remove unused Nix code

    # Optional: Additional Nix tools
    # nixfmt                # Nix code formatter (official)
    # alejandra             # Alternative Nix formatter (opinionated)
    # nil                   # Nix language server for LSP
    # nix-tree              # Visualize dependency trees
    # nix-diff              # Compare Nix derivations
    # nixpkgs-review        # Review nixpkgs pull requests
    # nix-update            # Update package versions
  ];

  # ============================================================================
  # Optional: Nix Development Settings
  # ============================================================================
  # nix.settings = {
  #   # Keep build dependencies for development
  #   keep-derivations = true;
  #   keep-outputs = true;
  # };
}
