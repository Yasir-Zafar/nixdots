# hm/development/editors/jetbrains.nix
{
  config,
  pkgs,
  ...
}: {
  # # JetBrains IDEs
  home.packages = with pkgs; [
    #   # Java development
    #   jetbrains.idea-ultimate
    #
    #   # Python development
    #   jetbrains.pycharm-professional
    #
    #   # JavaScript/Web development
    #   jetbrains.webstorm
    #
    #   # c++
    #   jetbrains.clion
    #
    #   # Database management
    #   jetbrains.datagrip

    jetbrains.rustrover

    jetbrains-toolbox
  ];
}
