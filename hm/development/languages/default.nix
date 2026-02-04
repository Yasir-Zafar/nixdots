# ============================================================================
# Development Languages Configuration
# Location: hm/development/languages/default.nix
# ============================================================================
{
  imports = [
    ./java.nix # Java development environment
    ./javascript.nix # Node.js and JavaScript tools
    ./python.nix # Python development environment
    ./rust.nix # Uncomment if needed
    # ./go.nix # Uncomment if needed
    # ./cpp.nix # Uncomment if needed
  ];
}
