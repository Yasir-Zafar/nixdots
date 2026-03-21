{pkgs, ...}: {
  environment = {
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      BROWSER = "zen-beta";
      MANPAGER = "nvim +Man!";

      PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    };

    sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";

      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };

    loginShellInit = ''
      export PATH="$HOME/.local/bin:$PATH"
    '';

    interactiveShellInit = ''
      export HISTSIZE=10000
      export HISTFILESIZE=20000
    '';
  };
}
