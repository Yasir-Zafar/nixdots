# nixos/development/python.nix
{pkgs, ...}: {
  # System-wide language runtimes
  environment.systemPackages = with pkgs; [
    # Python
    python3
    python3Packages.pip
    python3Packages.virtualenv

    # Python development tools
    python3Packages.black
    python3Packages.flake8
    python3Packages.mypy
  ];
}
