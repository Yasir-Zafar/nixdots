{
  description = "rust project";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...}: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in {
    devShells.x86_64-linux.default = pkgs.mkShell {
      packages = with pkgs; [cargo rustc rustfmt clippy rust-analyzer bacon pkg-config];
      # native deps (openssl etc.) go here instead of a global PKG_CONFIG_PATH
      buildInputs = with pkgs; [openssl];
      RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
    };
  };
}
