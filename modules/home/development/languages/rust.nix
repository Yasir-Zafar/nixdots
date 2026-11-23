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
      # native deps (openssl, pkg-config) belong in the project's dev shell
    ];

    # ~/.local/share/cargo/bin is on PATH via shell/environment.nix
    # sessionVariables.PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };
}
