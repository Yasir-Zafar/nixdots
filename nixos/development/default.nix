# nixos/development/default.nix
# Development tools and environments
{pkgs, ...}: {
  # ============================================================================
  # Language-Specific Configurations
  # ============================================================================
  imports = [
    ./java.nix # Java development (JDK, Maven, Gradle)
    ./python.nix # Python development (pip, virtualenv, linters)
    ./nix.nix # Nix development tools (statix, deadnix)
    ./android.nix # Android development (Android Studio, ADB)
  ];

  # ============================================================================
  # Core Development Tools
  # ============================================================================
  # Tools that need system-level access or are used across projects
  environment.systemPackages = with pkgs; [
    # Version Control
    git # Distributed version control

    # Build Essentials
    gnumake # GNU Make build automation
    gcc-unwrapped # GNU Compiler Collection (C/C++)
    pkg-config # Helper tool for compiling applications

    # Debugging & Profiling
    gdb # GNU Debugger
    valgrind # Memory debugging and profiling
  ];

  # ============================================================================
  # Development Services
  # ============================================================================

  # Optional: Enable Docker for containerized development
  # virtualisation.docker = {
  #   enable = true;
  #   enableOnBoot = true;
  # };
}
