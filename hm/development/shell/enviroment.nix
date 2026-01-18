# hm/development/shell/environment.nix
{config, ...}: {
  # User session variables (Home Manager)
  home.sessionVariables = {
    # User-specific development variables
    EDITOR = "nvim";
    BROWSER = "zen-beta";
    TERMINAL = "ghostty";

    # Development environment
    GOPATH = "${config.home.homeDirectory}/go";
    CARGO_HOME = "${config.home.homeDirectory}/.cargo";
    RUSTUP_HOME = "${config.home.homeDirectory}/.rustup";

    # User preferences
    BAT_THEME = "Gruvbox";

    # Gaming optimizations (user-level)
    MANGOHUD = "1";
    __GL_THREADED_OPTIMIZATIONS = "1";

    ANDROID_HOME = "$HOME/Android/Sdk";
    ANDROID_SDK_ROOT = "$ANDROID_HOME";
    PATH = "$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools";
  };

  # Variables for specific programs
  programs.bash.sessionVariables = {
    # Bash-specific variables
    HISTCONTROL = "ignoreboth";
  };

  programs.zsh.sessionVariables = {
    # Zsh-specific variables
    HIST_STAMPS = "yyyy-mm-dd";
  };
}
