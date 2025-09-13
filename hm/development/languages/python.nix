# hm/development/languages/python.nix
{
  config,
  pkgs,
  ...
}: {
  home = {
    # Python development packages
    packages = with pkgs; [
      # Python interpreters
      python3
      python311

      # Python tools
      python3Packages.pip
      python3Packages.virtualenv
      python3Packages.pipenv
      poetry

      # Development tools
      python3Packages.black
      python3Packages.flake8
      python3Packages.mypy
      python3Packages.pytest
      python3Packages.ipython
      python3Packages.jupyter

      # Popular packages for development
      python3Packages.requests
      python3Packages.numpy
      python3Packages.pandas
    ];

    # Python environment variables
    sessionVariables = {
      PYTHONPATH = "$HOME/.local/lib/python3.11/site-packages:$PYTHONPATH";
    };

    # Pip configuration
    file.".pip/pip.conf".text = ''
      [global]
      user = true

      [install]
      user = true
    '';
  };
}
