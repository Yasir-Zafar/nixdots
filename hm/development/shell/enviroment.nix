# ============================================================================
# Environment Variables Configuration
# Location: hm/development/shell/environment.nix
# ============================================================================
{config, ...}: {
  # ==========================================================================
  # USER SESSION VARIABLES
  # ==========================================================================
  # These apply to all shells and GUI applications
  home.sessionVariables = {
    # ------------------------------------------------------------------------
    # Default Applications
    # ------------------------------------------------------------------------
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "zen-beta";
    TERMINAL = "ghostty";

    # ------------------------------------------------------------------------
    # Development Tools
    # ------------------------------------------------------------------------
    # Go development
    GOPATH = "${config.home.homeDirectory}/go";
    GOBIN = "${config.home.homeDirectory}/go/bin";

    # Rust development
    CARGO_HOME = "${config.home.homeDirectory}/.cargo";
    RUSTUP_HOME = "${config.home.homeDirectory}/.rustup";

    # Android development
    ANDROID_HOME = "${config.home.homeDirectory}/Android/Sdk";
    ANDROID_SDK_ROOT = "${config.home.homeDirectory}/Android/Sdk";

    # ------------------------------------------------------------------------
    # Tool Preferences
    # ------------------------------------------------------------------------
    # Bat (cat replacement) theme
    BAT_THEME = "Gruvbox";

    # FZF (fuzzy finder) options
    # FZF_DEFAULT_OPTS = "--height 40% --layout=reverse --border";

    # Less pager options
    LESS = "-R"; # Raw control characters (for colors)

    # Ripgrep config file
    RIPGREP_CONFIG_PATH = "${config.home.homeDirectory}/.ripgreprc";

    # ------------------------------------------------------------------------
    # Performance & Gaming
    # ------------------------------------------------------------------------
    # Enable MangoHud for game performance overlay
    MANGOHUD = "1";

    # NVIDIA threaded optimizations
    __GL_THREADED_OPTIMIZATIONS = "1";

    # Optional: Force specific GPU for applications
    # __NV_PRIME_RENDER_OFFLOAD = "1";
    # __GLX_VENDOR_LIBRARY_NAME = "nvidia";

    # ------------------------------------------------------------------------
    # Language & Locale
    # ------------------------------------------------------------------------
    # Ensure UTF-8 encoding
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";

    # ------------------------------------------------------------------------
    # XDG Base Directories
    # ------------------------------------------------------------------------
    # Following XDG Base Directory specification
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
    XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
    XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
    XDG_STATE_HOME = "${config.home.homeDirectory}/.local/state";

    # ------------------------------------------------------------------------
    # Development Environment
    # ------------------------------------------------------------------------
    # Node.js environment (set in javascript.nix, but can override here)
    # NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm-global";

    # Python environment (set in python.nix, but can override here)
    # PYTHONPATH = "${config.home.homeDirectory}/.local/lib/python3.11/site-packages";

    # Java environment (set in java.nix, but can override here)
    # JAVA_HOME = "${pkgs.jdk21}";
  };

  # ==========================================================================
  # SESSION PATH
  # ==========================================================================
  # Add directories to PATH
  home.sessionPath = [
    # User binaries
    "${config.home.homeDirectory}/.local/bin"

    # Go binaries
    "${config.home.homeDirectory}/go/bin"

    # Rust binaries
    "${config.home.homeDirectory}/.cargo/bin"

    # npm global binaries (set in javascript.nix)
    "${config.home.homeDirectory}/.npm-global/bin"

    # Android SDK tools
    "${config.home.homeDirectory}/Android/Sdk/emulator"
    "${config.home.homeDirectory}/Android/Sdk/platform-tools"

    # Optional: Add custom scripts directory
    # "${config.home.homeDirectory}/scripts"
  ];

  # ==========================================================================
  # BASH-SPECIFIC VARIABLES
  # ==========================================================================
  programs.bash.sessionVariables = {
    # Bash history configuration
    HISTCONTROL = "ignoreboth"; # ignoredups:ignorespace
    HISTSIZE = "10000";
    HISTFILESIZE = "10000";

    # Bash history timestamp format
    HISTTIMEFORMAT = "%F %T ";
  };

  # ==========================================================================
  # ZSH-SPECIFIC VARIABLES (if using Zsh)
  # ==========================================================================
  programs.zsh.sessionVariables = {
    # Zsh history configuration
    HIST_STAMPS = "yyyy-mm-dd";

    # Zsh options
    # CASE_SENSITIVE = "false";
    # HYPHEN_INSENSITIVE = "true";
  };

  # ==========================================================================
  # CONFIGURATION FILES FOR TOOLS
  # ==========================================================================

  # Ripgrep configuration
  home.file.".ripgreprc".text = ''
    # Search hidden files
    --hidden

    # Follow symlinks
    --follow

    # Ignore .git directories
    --glob=!.git/*

    # Ignore node_modules
    --glob=!node_modules/*

    # Ignore build directories
    --glob=!target/*
    --glob=!build/*
    --glob=!dist/*

    # Smart case (case-insensitive unless uppercase used)
    --smart-case

    # Show line numbers
    --line-number
  '';

  # Starship prompt configuration (if using Starship)
  # programs.starship = {
  #   enable = true;
  #   settings = {
  #     add_newline = false;
  #     character = {
  #       success_symbol = "[➜](bold green)";
  #       error_symbol = "[➜](bold red)";
  #     };
  #   };
  # };
}
# ============================================================================
# ENVIRONMENT VARIABLE BEST PRACTICES
# ============================================================================
# 1. Use XDG Base Directory specification for better organization
# 2. Keep tool-specific configs in separate files
# 3. Document why each variable is needed
# 4. Avoid hardcoding paths when possible
# 5. Use ${config.home.homeDirectory} instead of $HOME in Nix
#
# Common environment variables to consider:
# - PAGER: less, bat, or moar
# - MANPAGER: bat for colored man pages
# - SUDO_EDITOR: editor for sudo -e
# - GIT_EDITOR: editor for git commits
# - DOCKER_HOST: Docker daemon host
# ============================================================================

