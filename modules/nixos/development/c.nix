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

  environment.variables = {
    CC = "clang";
    CXX = "clang++";
    # clang-tools is in systemPackages above, so clangd/clang-format are already on PATH
  };
}
