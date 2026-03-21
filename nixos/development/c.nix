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
    bear
  ];

  environment.variables = {
    CC = "clang";
    CXX = "clang++";
    PATH = "${pkgs.clang-tools}/bin:\${PATH}";
  };
}
