# Rust: rust-analyzer through rustaceanvim (it starts the server itself, so there is no
# lsp.servers.rust_analyzer in lsp.nix; the lsp.nix keys and inlay hint toggle still apply),
# and crates.nvim for Cargo.toml.
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

    # versions, features and docs inside Cargo.toml; through its in-process language server,
    # so completion, hover and code actions arrive via blink.cmp and the usual LSP keys
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
