{
  description = "c / c++ project";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...}: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in {
    # clangStdenv: CC/CXX are clang inside this shell only
    devShells.x86_64-linux.default = pkgs.mkShell.override {stdenv = pkgs.clangStdenv;} {
      packages = with pkgs; [clang-tools cmake meson ninja gnumake pkg-config lldb];
    };
  };
}
