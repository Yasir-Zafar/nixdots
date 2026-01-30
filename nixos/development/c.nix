# nixos/development/cpp.nix
# C / C++ development environment
{pkgs, ...}: {
  # ============================================================================
  # C / C++ Packages
  # ============================================================================
  environment.systemPackages = with pkgs; [
    # Compilers
    gcc # GNU C/C++ compiler
    clang # LLVM C/C++ compiler

    # Tooling
    clang-tools # clang-tidy, clang-format, etc.
    lldb # LLVM debugger
    gdb # GNU debugger

    # Build systems
    cmake
    meson
    ninja
    gnumake

    # Utilities
    pkg-config
    bear # Generate compile_commands.json (important for clang-tidy)
  ];

  # ============================================================================
  # Environment Variables (explicit PATH export – yes, we know)
  # ============================================================================
  environment.variables = {
    CC = "clang";
    CXX = "clang++";

    # Explicitly expose clang-tools binaries
    PATH = "${pkgs.clang-tools}/bin:\${PATH}";
  };
}
