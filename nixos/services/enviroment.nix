# nixos/services/environment.nix
# System-wide environment variables and shell configuration
{pkgs, ...}: {
  environment = {
    # ============================================================================
    # System-Wide Variables
    # ============================================================================
    # Available everywhere in the system (including systemd services)
    variables = {
      # Default applications
      EDITOR = "nvim";
      VISUAL = "nvim";
      BROWSER = "zen-beta";
      MANPAGER = "nvim +Man!"; # Use nvim for man pages

      # Development paths
      PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";

      # Hardware acceleration (for Intel graphics)
      VDPAU_DRIVER = "va_gl";
    };

    # ============================================================================
    # Session Variables
    # ============================================================================
    # Available in user sessions and GUI applications
    sessionVariables = {
      # Wayland support for applications
      MOZ_ENABLE_WAYLAND = "1"; # Firefox/Thunderbird Wayland
      QT_QPA_PLATFORM = "wayland"; # Qt apps on Wayland
      SDL_VIDEODRIVER = "wayland"; # SDL2 games on Wayland

      # Desktop environment
      XDG_CURRENT_DESKTOP = "GNOME";
      XDG_SESSION_TYPE = "wayland";

      ELECTRON_OZONE_PLATFORM_HINT = "x11";
    };

    # ============================================================================
    # Login Shell Initialization
    # ============================================================================
    # Runs when opening a login shell (e.g., via SSH, TTY)
    loginShellInit = ''
      # Add user's local bin to PATH
      export PATH="$HOME/.local/bin:$PATH"

      # Optional: Add custom paths
      # export PATH="$HOME/.cargo/bin:$PATH"
      # export PATH="$HOME/go/bin:$PATH"
    '';

    # ============================================================================
    # Interactive Shell Initialization
    # ============================================================================
    # Runs for interactive shells (terminal windows)
    interactiveShellInit = ''
      # Shell history settings
      export HISTSIZE=10000
      export HISTFILESIZE=20000

      # Optional: Bash-specific history control
      # export HISTCONTROL=ignoreboth:erasedups
      # export HISTTIMEFORMAT="%F %T "
    '';
  };
}
