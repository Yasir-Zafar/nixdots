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
      python3 # Python 3 (latest stable)
      # python311 # Alternative: Specific Python 3.11
      # python312 # Alternative: Specific Python 3.12

      # ------------------------------------------------------------------------
      # Package Managers & Virtual Environments
      # ------------------------------------------------------------------------
      python3Packages.pip # Package installer
      python3Packages.virtualenv # Virtual environment tool
      python3Packages.pipx # Install Python apps in isolated environments
      poetry # Modern dependency management
      # pdm # Alternative: Python Development Master
      # rye # Alternative: Experimental Python tool

      # ------------------------------------------------------------------------
      # Code Quality Tools
      # ------------------------------------------------------------------------
      python3Packages.black # Code formatter
      python3Packages.flake8 # Linter
      python3Packages.pylint # Static code analyzer
      python3Packages.mypy # Type checker
      python3Packages.isort # Import sorter
      ruff # Fast Python linter (Rust-based)

      # ------------------------------------------------------------------------
      # Testing Tools
      # ------------------------------------------------------------------------
      python3Packages.pytest # Testing framework
      python3Packages.pytest-cov # Coverage plugin
      # python3Packages.tox # Testing automation

      # ------------------------------------------------------------------------
      # Interactive Development
      # ------------------------------------------------------------------------
      python3Packages.ipython # Enhanced interactive shell
      python3Packages.jupyter # Jupyter notebooks
      python3Packages.jupyterlab # JupyterLab interface

      # ------------------------------------------------------------------------
      # Common Development Libraries
      # ------------------------------------------------------------------------
      python3Packages.requests # HTTP library
      python3Packages.numpy # Numerical computing
      python3Packages.pandas # Data analysis
      python3Packages.matplotlib # Plotting library

      # Uncomment as needed:
      # python3Packages.scipy # Scientific computing
      # python3Packages.scikit-learn # Machine learning
      # python3Packages.tensorflow # Deep learning
      # python3Packages.django # Web framework
      # python3Packages.flask # Micro web framework
      # python3Packages.fastapi # Modern API framework
      # python3Packages.sqlalchemy # SQL toolkit
    ];

    # ========================================================================
    # PYTHON ENVIRONMENT VARIABLES
    # ========================================================================
    sessionVariables = {
      # Add user site-packages to Python path
      PYTHONPATH = "$HOME/.local/lib/python3.11/site-packages:$PYTHONPATH";

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
# ============================================================================
# PYTHON VERSION MANAGEMENT
# ============================================================================
# To use multiple Python versions:
#
# 1. Install specific versions:
#    home.packages = [ pkgs.python311 pkgs.python312 ];
#
# 2. Use pyenv (not recommended with Nix):
#    Better to use nix-shell or direnv
#
# 3. Project-specific Python with direnv:
#    # .envrc
#    use nix -p python311
# ============================================================================
# ============================================================================
# VIRTUAL ENVIRONMENT BEST PRACTICES
# ============================================================================
# 1. Create virtual environment:
#    python -m venv venv
#
# 2. Activate virtual environment:
#    source venv/bin/activate
#
# 3. Install project dependencies:
#    pip install -r requirements.txt
#
# 4. Or use poetry:
#    poetry install
#
# 5. Or use nix-shell for reproducibility:
#    Create shell.nix with project dependencies
# ============================================================================
# ============================================================================
# ADDITIONAL PYTHON TOOLS TO CONSIDER
# ============================================================================
# Development:
# - python3Packages.rich: Beautiful terminal output
# - python3Packages.typer: CLI framework
# - python3Packages.pydantic: Data validation
#
# Data Science:
# - python3Packages.seaborn: Statistical visualization
# - python3Packages.plotly: Interactive plots
# - python3Packages.opencv4: Computer vision
#
# Web Development:
# - python3Packages.uvicorn: ASGI server
# - python3Packages.celery: Distributed task queue
# - python3Packages.redis: Redis client
#
# Testing:
# - python3Packages.hypothesis: Property-based testing
# - python3Packages.mock: Mocking library
# ============================================================================

