{config, ...}: {
  home = {
    sessionVariables = {
      GOPATH = "${config.home.homeDirectory}/go";
      GOBIN = "${config.home.homeDirectory}/go/bin";
      CARGO_HOME = "${config.home.homeDirectory}/.cargo";
      RUSTUP_HOME = "${config.home.homeDirectory}/.rustup";
      ANDROID_HOME = "${config.home.homeDirectory}/Android/Sdk";
      ANDROID_SDK_ROOT = "${config.home.homeDirectory}/Android/Sdk";

      LESS = "-R";
      RIPGREP_CONFIG_PATH = "${config.home.homeDirectory}/.ripgreprc";
    };

    sessionPath = [
      "${config.home.homeDirectory}/.local/share/PrismLauncher"
      "${config.home.homeDirectory}/.local/bin"
      "${config.home.homeDirectory}/go/bin"
      "${config.home.homeDirectory}/.cargo/bin"
      "${config.home.homeDirectory}/.npm-global/bin"
      "${config.home.homeDirectory}/Android/Sdk/emulator"
      "${config.home.homeDirectory}/Android/Sdk/platform-tools"
    ];

    file.".ripgreprc".text = ''
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
  };
}
