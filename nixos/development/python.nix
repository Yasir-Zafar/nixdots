# nixos/development/python.nix
# Python development environment
{pkgs, ...}: {
  # ============================================================================
  # Python Packages
  # ============================================================================
  environment.systemPackages = with pkgs; [
    # Python Runtime
    python3 # Python 3 interpreter

    # Package Management
    python3Packages.pip # Package installer for Python
    python3Packages.virtualenv # Virtual environment creator

    # Development Tools
    python3Packages.black # Code formatter
    python3Packages.flake8 # Linting tool (style guide enforcement)
    python3Packages.mypy # Static type checker

    # Optional: Additional useful tools
    # python3Packages.pytest       # Testing framework
    # python3Packages.ipython      # Enhanced interactive shell
    # python3Packages.jupyter      # Jupyter notebooks
    # python3Packages.pylint       # Alternative linter
    # python3Packages.autopep8     # Auto code formatter
    # python3Packages.poetry       # Dependency management
    # python3Packages.pipenv       # Virtual environment manager
  ];

  # ============================================================================
  # Note: Consider using pyenv or poetry
  # ============================================================================
  # For better version management, consider:
  # - pyenv for managing multiple Python versions
  # - poetry for modern dependency management
  # - nix-shell for project-specific environments
}
