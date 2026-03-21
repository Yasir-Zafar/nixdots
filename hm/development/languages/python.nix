{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      python314
      python314Packages.pip
      python314Packages.virtualenv
      python314Packages.pipx
      python314Packages.black
      python314Packages.flake8
      python314Packages.pylint
      python314Packages.mypy
      python314Packages.isort
      ruff
    ];

    sessionVariables = {
      PYTHONPATH = "$HOME/.local/lib/python3.14/site-packages:$PYTHONPATH";
    };

    file.".pip/pip.conf".text = ''
      [global]
      user = true

      [install]
      user = true
    '';
  };
}
