{config, ...}: {
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "zen-beta";
    TERMINAL = "ghostty";

    GOPATH = "${config.home.homeDirectory}/go";
    GOBIN = "${config.home.homeDirectory}/go/bin";

    CARGO_HOME = "${config.home.homeDirectory}/.cargo";
    RUSTUP_HOME = "${config.home.homeDirectory}/.rustup";

    ANDROID_HOME = "${config.home.homeDirectory}/Android/Sdk";
    ANDROID_SDK_ROOT = "${config.home.homeDirectory}/Android/Sdk";

    BAT_THEME = "Gruvbox";
    LESS = "-R";
    RIPGREP_CONFIG_PATH = "${config.home.homeDirectory}/.ripgreprc";

    MANGOHUD = "1";
    __GL_THREADED_OPTIMIZATIONS = "1";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/go/bin"
    "${config.home.homeDirectory}/.cargo/bin"
    "${config.home.homeDirectory}/.npm-global/bin"
    "${config.home.homeDirectory}/Android/Sdk/emulator"
    "${config.home.homeDirectory}/Android/Sdk/platform-tools"
  ];

  programs.bash.sessionVariables = {
    HISTCONTROL = "ignoreboth";
    HISTSIZE = "10000";
    HISTFILESIZE = "10000";
    HISTTIMEFORMAT = "%F %T ";
  };

  programs.zsh.sessionVariables = {
    HIST_STAMPS = "yyyy-mm-dd";
  };

  home.file.".ripgreprc".text = ''
    --hidden
    --follow
    --glob=!.git/*
    --glob=!node_modules/*
    --glob=!target/*
    --glob=!build/*
    --glob=!dist/*
    --smart-case
    --line-number
  '';
}
