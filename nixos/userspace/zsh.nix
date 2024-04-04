{
  programs.zsh.enable = true;
  environment.pathsToLink = ["/share/zsh"];

  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    # ~/ Clean-up:
    GTK2_RC_FILES = "$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0";
    WGETRC = "$XDG_CONFIG_HOME/wget/wgetrc";
    HISTFILE = "$XDG_DATA_HOME/history";

    # Not officially in the specification
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [
      "${XDG_BIN_HOME}"
    ];
  };
}
