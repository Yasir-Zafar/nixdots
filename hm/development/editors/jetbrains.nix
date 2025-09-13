# hm/development/editors/jetbrains.nix
{
  config,
  pkgs,
  ...
}: {
  # JetBrains IDEs
  home.packages = with pkgs; [
    # Java development
    jetbrains.idea-ultimate

    # Python development
    jetbrains.pycharm-professional

    # JavaScript/Web development
    jetbrains.webstorm

    # Database management
    jetbrains.datagrip
  ];

  # JetBrains Toolbox (alternative way to manage JetBrains IDEs)
  # Uncomment if you prefer using Toolbox
  # home.packages = with pkgs; [
  #   jetbrains-toolbox
  # ];
}
