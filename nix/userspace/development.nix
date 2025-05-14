# userspace/development.nix
{ pkgs, ... }:

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
    clang_19
    llvmPackages.libcxx
    #llvmPackages.libcxxabi
    gdb

    python3
    python311Packages.pip
    nodejs
    rustup
    go
    jdk24
    lua
    luarocks

    # Database tools
    sqlite
    #pgcli
    #mycli

    # LSP servers
    clang-tools # For C/C++
    lua-language-server
    nil # Nix language server
    jdt-language-server # Java
    nodejs
    nodePackages.typescript
    nodePackages.typescript-language-server

    # Linters & formatters
    luaformatter
    stylua # Lua formatter
    nixpkgs-fmt # Nix formatter
    statix # Nix linter
    checkstyle # Java linter
    google-java-format # Java formatter
    nodePackages.eslint
    nodePackages.prettier
    lua52Packages.luacheck

    neovim
  ];

  environment.variables = {
    PATH = [
      "${pkgs.clang_19}/bin" # Compiler in PATH
      "${pkgs.clang-tools}/bin"
      "${pkgs.stylua}/bin"
      "${pkgs.lua-language-server}/bin"
      "${pkgs.nil}/bin"
      "${pkgs.jdt-language-server}/bin"
      "${pkgs.nodePackages.typescript-language-server}/bin"
    ];
    CPLUS_INCLUDE_PATH = [
      "${pkgs.llvmPackages.libcxx}/include/c++/v1"
      "${pkgs.llvmPackages.clang}/resource/include"
    ];

    # Help the linker find libraries
    LIBRARY_PATH = [
      "${pkgs.llvmPackages.libcxx}/lib"
      #"${pkgs.llvmPackages.libcxxabi}/lib"
    ];
  };
}
