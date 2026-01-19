# ============================================================================
# Development Editors Configuration
# Location: hm/development/editors/default.nix
# ============================================================================
{
  imports = [
    ./jetbrains.nix # JetBrains IDEs (IntelliJ, PyCharm, etc.)
    ./cursor.nix # Cursor AI editor
    ./vscode.nix # Visual Studio Code
  ];
}
