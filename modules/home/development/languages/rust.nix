{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      rustup
      cargo-edit
      # cargo-watch # unmaintained; bacon is the replacement
      bacon
      cargo-audit
      cargo-outdated

      taplo
      # openssl, pkg-config, libiconv: native deps belong in the project's dev shell
      # (templates/rust wires openssl + pkg-config); globally they never linked anyway
    ];

    # ~/.cargo/bin is on PATH via shell/environment.nix
    # sessionVariables.PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };
}
