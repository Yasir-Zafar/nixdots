# nixos/services/environment.nix
{pkgs, ...}: {
  environment = {
    # System-wide environment variables
    variables = {
      # System-level variables that need to be available everywhere
      EDITOR = "nvim";
      BROWSER = "zen-beta";

      # Development paths that should be system-wide
      PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";

      # Hardware-specific variables
      VDPAU_DRIVER = "va_gl"; # For Intel graphics

      VISUAL = "nvim";
      MANPAGER = "nvim +Man!";
    };

    # Session variables (available in user sessions, including display managers)
    sessionVariables = {
      # Variables that need to be available in GUI sessions
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";

      # XDG variables
      XDG_CURRENT_DESKTOP = "GNOME";
      XDG_SESSION_TYPE = "wayland";
    };

    # Variables for login shells
    loginShellInit = ''
      # Additional shell initialization
      export PATH="$HOME/.local/bin:$PATH"
    '';

    # Variables for interactive shells
    interactiveShellInit = ''
      # Shell-specific initialization
      export HISTSIZE=10000
      export HISTFILESIZE=20000
    '';
  };
}
