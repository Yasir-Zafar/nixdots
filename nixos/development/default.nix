# nixos/development/default.nix
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./java.nix
    ./python.nix
    ./nix.nix
    ./bugzilla.nix
  ];

  # Development tools that need system-level access
  environment.systemPackages = with pkgs; [
    # Version control
    git

    # Build tools
    gnumake
    gcc

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
