# hm/development/editors/cursor.nix
{pkgs, ...}: {
  # # JetBrains IDEs
  home.packages = with pkgs; [
    code-cursor
    windsurf
  ];
}
