# Rust: rustaceanvim starts rust-analyzer itself (none in lsp.nix); crates.nvim for Cargo.toml
#   :RustLsp runnables | debuggables | testables | expandMacro | explainError | renderDiagnostic
#   | hover actions | joinLines | parentModule | openDocs     (Cargo.toml: :Crates …)
{pkgs, ...}: {
  programs.nixvim = {
    plugins.rustaceanvim = {
      enable = true;
      settings = {
        server.default_settings.rust-analyzer = {
          check.command = "clippy"; # use clippy instead of check on save
          cargo.allFeatures = true;
          inlayHints = {
            bindingModeHints.enable = true;
            closureReturnTypeHints.enable = "with_block";
          };
        };

        # :RustLsp debuggables through the same lldb-dap as dap.nix (no codelldb)
        dap.adapter = {
          type = "executable";
          command = "${pkgs.lldb}/bin/lldb-dap";
          name = "rt_lldb";
        };
      };
    };

    # cargo + rustc on nvim's PATH for rust-analyzer (rust-analyzer itself comes with the plugin)
    extraPackages = with pkgs; [cargo rustc];

    # crates.nvim: versions/features/docs in Cargo.toml, through blink.cmp and the LSP keys
    plugins.crates = {
      enable = true;
      settings.lsp = {
        enabled = true;
        actions = true;
        completion = true;
        hover = true;
      };
    };
  };
}
