{pkgs, ...}: {
  home.packages = with pkgs; [
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

  home.sessionPath = [
    "$HOME/.cargo/bin"
  ];
  home.sessionVariables = {
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };
}
