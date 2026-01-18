# nixos/development/default.nix
{pkgs, ...}: {
  imports = [
    ./java.nix
    ./python.nix
    ./nix.nix
    ./android.nix
  ];

  # Development tools that need system-level access
  environment.systemPackages = with pkgs; [
    # Version control
    git

    # Build tools
    gnumake
    gcc-unwrapped

    # System development
    pkg-config

    # Debugging
    gdb
    valgrind
  ];

  # Enable development services
  services.postgresql = {
    enable = false; # Enable if you need PostgreSQL
    package = pkgs.postgresql_15;
  };
}
