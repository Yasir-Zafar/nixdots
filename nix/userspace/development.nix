# userspace/development.nix
{ config, lib, pkgs, ... }:

{
  # Install development packages
  environment.systemPackages = with pkgs; [
    # Version control
    git
    gitui
    lazygit
    gh
    
    # Build tools
    gnumake
    cmake
    ninja
    meson
    automake
    autoconf
    libtool
    pkg-config
    
    # C/C++ development
    clang-tools
    llvm
    clang
    python3
    python311Packages.pip
    poetry
    nodejs
    rustup
    go
    jdk24
    lua
    luarocks
    
    # Database tools
    sqlite
    pgcli
    mycli
    
    # Language formatters
    black
    stylua
    shfmt
    alejandra
    shfmt              # Shell
    beautysh           # Bash beautifier
    rustfmt            # Rust
  ];

}
