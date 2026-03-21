{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      rustup
      cargo-edit
      cargo-watch
      cargo-audit
      cargo-outdated

      pkg-config
      openssl
      libiconv

      taplo
    ];

    sessionPath = [
      "$HOME/.cargo/bin"
    ];
  };
}
