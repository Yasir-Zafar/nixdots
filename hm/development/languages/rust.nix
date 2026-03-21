{pkgs, ...}: {
  home.packages = with pkgs; [
    rustup
    cargo-edit
    cargo-watch
    cargo-audit
    cargo-outdated

    openssl
    libiconv
    taplo
  ];

  home.sessionPath = [
    "$HOME/.cargo/bin"
  ];
}
