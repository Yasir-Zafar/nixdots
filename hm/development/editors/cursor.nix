# ============================================================================
# Cursor AI Editor Configuration
# Location: hm/development/editors/cursor.nix
# ============================================================================
# Cursor is an AI-powered code editor built on VSCode.
# Windsurf is another AI coding assistant.
# ============================================================================
{pkgs, ...}: {
  home.packages = with pkgs; [
    code-cursor # Cursor AI editor
    windsurf # Windsurf AI coding assistant
  ];
}
