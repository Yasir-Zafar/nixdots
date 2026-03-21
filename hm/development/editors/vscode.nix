{pkgs, ...}: {
  home.packages = with pkgs; [
    vscode
    code-cursor
    windsurf
  ];
}
