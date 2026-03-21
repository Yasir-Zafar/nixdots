# ============================================================================
# Python Development Environment
# Location: hm/development/languages/python.nix
# ============================================================================
{pkgs, ...}: {
  home = {
    # ========================================================================
    # PYTHON PACKAGES
    # ========================================================================
    packages = with pkgs; [
      # ------------------------------------------------------------------------
      # Python Interpreters
      # ------------------------------------------------------------------------
      python314 # Python 3 (latest stable)
      # python31411 # Alternative: Specific Python 3.11
      # python31412 # Alternative: Specific Python 3.12

      # ------------------------------------------------------------------------
      # Package Managers & Virtual Environments
      # ------------------------------------------------------------------------
      python314Packages.pip # Package installer
      python314Packages.virtualenv # Virtual environment tool
      python314Packages.pipx # Install Python apps in isolated environments
      # poetry # Modern dependency management
      # pdm # Alternative: Python Development Master
      # rye # Alternative: Experimental Python tool

      # ------------------------------------------------------------------------
      # Code Quality Tools
      # ------------------------------------------------------------------------
      python314Packages.black # Code formatter
      python314Packages.flake8 # Linter
      python314Packages.pylint # Static code analyzer
      python314Packages.mypy # Type checker
      python314Packages.isort # Import sorter
      ruff # Fast Python linter (Rust-based)
    ];

    # ========================================================================
    # PYTHON ENVIRONMENT VARIABLES
    # ========================================================================
    sessionVariables = {
      # Add user site-packages to Python path
      PYTHONPATH = "$HOME/.local/lib/python3.14/site-packages:$PYTHONPATH";

      # Optional: Disable .pyc files for development
      # PYTHONDONTWRITEBYTECODE = "1";

      # Optional: Enable Python development mode
      # PYTHONDEVMODE = "1";
    };

    # ========================================================================
    # PIP CONFIGURATION
    # ========================================================================
    file.".pip/pip.conf".text = ''
      [global]
      # Install to user site-packages by default
      user = true

      [install]
      user = true

      # Optional: Use specific index
      # index-url = https://pypi.org/simple

      # Optional: Require virtual environment
      # require-virtualenv = true
    '';

    # ========================================================================
    # POETRY CONFIGURATION (Optional)
    # ========================================================================
    # file.".config/pypoetry/config.toml".text = ''
    #   [virtualenvs]
    #   in-project = true
    #   create = true
    # '';

    # ========================================================================
    # IPYTHON CONFIGURATION (Optional)
    # ========================================================================
    # file.".ipython/profile_default/ipython_config.py".text = ''
    #   c = get_config()
    #   c.InteractiveShell.colors = 'Linux'
    #   c.InteractiveShell.confirm_exit = False
    # '';
  };
}
