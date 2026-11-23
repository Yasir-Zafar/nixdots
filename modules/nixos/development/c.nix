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

  # CC/CXX not forced to clang globally; templates/c has a clang stdenv
  # environment.variables = {
  #   CC = "clang";
  #   CXX = "clang++";
  # };
}
