{config, ...}: let
  inherit (config.xdg) configHome dataHome cacheHome;
in {
  home = {
    sessionVariables = {
      # tools that would otherwise put a folder straight in ~ (see xdg-ninja)
      GOPATH = "${dataHome}/go";
      GOBIN = "${dataHome}/go/bin";
      CARGO_HOME = "${dataHome}/cargo";
      RUSTUP_HOME = "${dataHome}/rustup";
      NPM_CONFIG_CACHE = "${cacheHome}/npm";
      DOCKER_CONFIG = "${configHome}/docker";
      WINEPREFIX = "${dataHome}/wine";
      IPYTHONDIR = "${configHome}/ipython";
      JUPYTER_CONFIG_DIR = "${configHome}/jupyter";
      # ~/.java (font cache stays: java ignores this for it). Every java run prints
      # "Picked up _JAVA_OPTIONS" because of it (minecraft, jetbrains, gradle)
      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${configHome}/java";
      NPM_CONFIG_USERCONFIG = "${configHome}/npm/npmrc";
      # only the config file moves; aws keeps its cli/ and login/ caches in ~/.aws
      AWS_CONFIG_FILE = "${configHome}/aws/config";
      ANDROID_HOME = "${config.home.homeDirectory}/Android/Sdk";
      ANDROID_SDK_ROOT = "${config.home.homeDirectory}/Android/Sdk";

      LESS = "-R";
      RIPGREP_CONFIG_PATH = "${configHome}/ripgrep/ripgreprc";
    };

    sessionPath = [
      "${config.home.homeDirectory}/.local/share/PrismLauncher"
      "${config.home.homeDirectory}/.local/bin"
      "${dataHome}/go/bin"
      "${dataHome}/cargo/bin"
      "${config.home.homeDirectory}/.npm-global/bin"
      "${config.home.homeDirectory}/Android/Sdk/emulator"
      "${config.home.homeDirectory}/Android/Sdk/platform-tools"
    ];
  };

  xdg.configFile."ripgrep/ripgreprc".text = ''
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
