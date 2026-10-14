{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      rustup
      cargo-edit
      cargo-watch
      cargo-audit
      cargo-outdated

      openssl
      pkg-config
      libiconv
      taplo
    ];

    # ~/.cargo/bin is on PATH via shell/environment.nix
    sessionVariables = {
      PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    };
  };
}
