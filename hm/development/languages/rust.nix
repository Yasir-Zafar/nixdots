{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      # ------------------------------------------------------------------------
      # Rust Toolchain Bootstrap
      # ------------------------------------------------------------------------
      rustup # Official Rust toolchain manager (RECOMMENDED)
      cargo-edit # cargo add / rm / upgrade
      cargo-watch # Rebuild on file change
      cargo-audit # Security audits
      cargo-outdated # Check outdated deps

      # ------------------------------------------------------------------------
      # System Dependencies Commonly Needed by Rust Crates
      # ------------------------------------------------------------------------
      pkg-config
      openssl
      libiconv
      cmake
      clang
      llvm
      lldb

      # ------------------------------------------------------------------------
      # Formatting / Linting Helpers (optional but useful)
      # ------------------------------------------------------------------------
      taplo # TOML formatter (Cargo.toml)
    ];

    # ========================================================================
    # RUSTUP ENVIRONMENT
    # ========================================================================
    sessionPath = [
      "$HOME/.cargo/bin"
    ];
  };
}
