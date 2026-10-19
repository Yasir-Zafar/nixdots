# debugger with VS Code's keys (F5 / F9 / F10 / F11): rust + c/c++ through lldb-dap, python through debugpy
# (the kickstart go version stays in kickstart/plugins/debug.nix, switched off).
# lldb-dap instead of codelldb (vscode-lldb-adapter): nixpkgs has no binary cache for it, it compiles a rust toolchain
{pkgs, ...}: {
  programs.nixvim = {
    plugins = {
      dap = {
        enable = true;
        adapters.executables.lldb.command = "${pkgs.lldb}/bin/lldb-dap";
        configurations = let
          launch = default: {
            name = "Launch (lldb)";
            type = "lldb";
            request = "launch";
            cwd = "\${workspaceFolder}";
            program.__raw = "function() return vim.fn.input('Executable: ', vim.fn.getcwd() .. '${default}', 'file') end";
            stopOnEntry = false;
          };
        in {
          c = [(launch "/")];
          cpp = [(launch "/")];
          rust = [(launch "/target/debug/")];
        };
      };
      dap-ui.enable = true; # variables / stack / breakpoints panels, open while a session runs
      dap-virtual-text.enable = true; # values next to the code
      dap-python.enable = true;
    };

    extraConfigLua = ''
      local dap, dapui = require('dap'), require('dapui')
      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close
    '';

    keymaps = let
      dap = key: fn: desc: {
        mode = "n";
        inherit key;
        action.__raw = "function() require('dap').${fn} end";
        options.desc = "Debug: ${desc}";
      };
    in [
      (dap "<F5>" "continue()" "start / continue")
      (dap "<S-F5>" "terminate()" "stop")
      (dap "<F9>" "toggle_breakpoint()" "toggle breakpoint")
      (dap "<F10>" "step_over()" "step over")
      (dap "<F11>" "step_into()" "step into")
      (dap "<S-F11>" "step_out()" "step out")
      (dap "<leader>db" "toggle_breakpoint()" "toggle [b]reakpoint")
      (dap "<leader>dB" "set_breakpoint(vim.fn.input 'Condition: ')" "conditional [B]reakpoint")
      (dap "<leader>dc" "continue()" "[c]ontinue")
      (dap "<leader>dq" "terminate()" "[q]uit session")
      (dap "<leader>dl" "run_last()" "run [l]ast")
      {
        mode = "n";
        key = "<leader>du";
        action.__raw = "function() require('dapui').toggle() end";
        options.desc = "Debug: toggle [u]i";
      }
      {
        mode = ["n" "v"];
        key = "<leader>de";
        action.__raw = "function() require('dapui').eval() end";
        options.desc = "Debug: [e]valuate";
      }
    ];
  };
}
