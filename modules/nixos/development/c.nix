{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    gcc
    clang
    clang-tools
    lldb
    cmake
    meson
    ninja
    gnumake
    pkg-config

    ispc
  ];

  # The compilers stay installed globally for quick one-off builds. CC/CXX are no longer
  # forced to clang system-wide (that leaked into every build run by hand); a project
  # that wants clang gets it from templates/c (clang stdenv).
  # environment.variables = {
  #   CC = "clang";
  #   CXX = "clang++";
  # };
}
