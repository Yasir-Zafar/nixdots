{
  config,
  pkgs,
  ...
}: {
  # # JetBrains IDEs
  home.packages = with pkgs; [
    vscode
  ];
}
