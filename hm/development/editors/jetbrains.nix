# ============================================================================
# JetBrains IDEs Configuration
# Location: hm/development/editors/jetbrains.nix
# ============================================================================
{pkgs, ...}: {
  home.packages = with pkgs; [
    # ------------------------------------------------------------------------
    # JetBrains Toolbox
    # ------------------------------------------------------------------------
    # Recommended: Manage all JetBrains IDEs through Toolbox
    jetbrains-toolbox # IDE manager and updater

    # ------------------------------------------------------------------------
    # Individual JetBrains IDEs (Commented Out)
    # ------------------------------------------------------------------------
    # Uncomment the IDEs you need. Using JetBrains Toolbox is recommended
    # as it provides automatic updates and better version management.

    # Java Development
    # jetbrains.idea-ultimate # IntelliJ IDEA Ultimate
    # jetbrains.idea-community # IntelliJ IDEA Community (Free)

    # Python Development
    # jetbrains.pycharm-professional # PyCharm Professional
    # jetbrains.pycharm-community # PyCharm Community (Free)

    # JavaScript/Web Development
    # jetbrains.webstorm # WebStorm

    # C/C++ Development
    # jetbrains.clion # CLion

    # Rust Development
    # jetbrains.rust-rover # RustRover

    # Go Development
    # jetbrains.goland # GoLand

    # PHP Development
    # jetbrains.phpstorm # PhpStorm

    # Ruby Development
    # jetbrains.rubymine # RubyMine

    # Database Management
    # jetbrains.datagrip # DataGrip

    # .NET Development (Rider)
    # jetbrains.rider # Rider for C#/.NET

    # Android Development
    # android-studio # Android Studio (Google's distribution)
  ];
}
# ============================================================================
# PERFORMANCE TUNING
# ============================================================================
# For better performance on NixOS:
# 1. Increase IDE memory in Help → Edit Custom VM Options:
#    -Xmx4096m  # 4GB heap (adjust based on your RAM)
#
# 2. Exclude project directories from file watchers:
#    Settings → Directories → Mark as Excluded
#
# 3. Disable unnecessary plugins:
#    Settings → Plugins → Disable unused plugins
# ============================================================================
# ============================================================================
# COMMON PLUGINS TO CONSIDER
# ============================================================================
# Install through IDE or JetBrains Toolbox:
# - IdeaVim: Vim keybindings
# - GitToolBox: Enhanced Git integration
# - Rainbow Brackets: Color-coded bracket pairs
# - Key Promoter X: Learn keyboard shortcuts
# - String Manipulation: Text transformation tools
# - Nix Language Support: Nix syntax highlighting
# - .env files support: Environment variable files
# ============================================================================

