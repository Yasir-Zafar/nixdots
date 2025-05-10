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
    
    # Language servers & utilities
    
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
    gcc
    gdb
    clang-tools
    
    # Python development
    python3
    python311Packages.pip
    poetry
    black
    
    # Node.js development
    nodejs
    
    # Rust development
    rustup
    
    # Go development
    go
    
    # JVM development
    jdk24
    
    # Lua
    lua
    
    # Database tools
    sqlite
    pgcli
    mycli
    dbeaver
    
    # Editor and IDE
    neovim
    
    # Debugging tools
    
    # Documentation tools
    zeal
    
    # Testing tools
    
    # Docker tools
    
    # GitOps
    
    # Language formatters
    stylua
    shfmt
    nixpkgs-fmt
    
    # DevOps tools
    
  ];

}
