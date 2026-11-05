# nvim's side of the zellij workspace (docs/WORKFLOW.md): claude code in the next tab,
# lazygit opening files here, buffers following edits made by other panes
{
  programs.nixvim = {
    # claude code runs in its own zellij tab (`claude-ide`); this plugin is only the IDE side:
    # selection / diagnostics / open files go to claude, claude's edits come back as diffs here
    plugins.claudecode = {
      enable = true;
      settings = {
        terminal.provider = "none"; # no terminal inside nvim
        diff_opts = {
          layout = "vertical";
          open_in_new_tab = true; # keeps the window layout, the tab closes once the diff is resolved
        };
      };
    };
    # the plugin would put nixpkgs' claude-code on nvim's PATH; claude comes from the claude-code-nix overlay
    dependencies.claude-code.enable = false;

    # changes made on disk by claude, lazygit or a formatter show up without `:e`
    opts.autoread = true;

    autoGroups.workflow.clear = true;
    autoCmd = [
      {
        event = ["FocusGained" "BufEnter" "CursorHold" "CursorHoldI"];
        group = "workflow";
        desc = "Reload buffers changed on disk";
        callback.__raw = ''
          function()
            if vim.fn.mode() ~= 'c' and vim.fn.getcmdwintype() == "" then vim.cmd 'checktime' end
          end
        '';
      }
      {
        event = "FileChangedShellPost";
        group = "workflow";
        desc = "Say which buffer was reloaded";
        callback.__raw = ''
          function(ev)
            vim.notify('Reloaded ' .. vim.fn.fnamemodify(ev.file, ':~:.') .. ' (changed on disk)')
          end
        '';
      }
      {
        event = "FileType";
        pattern = "neo-tree";
        group = "workflow";
        desc = "Send the file under the cursor to claude";
        callback.__raw = ''
          function(ev)
            vim.keymap.set('n', '<leader>as', '<cmd>ClaudeCodeTreeAdd<cr>', { buffer = ev.buf, desc = 'Claude: add file' })
          end
        '';
      }
    ];

    keymaps = [
      {
        mode = "v";
        key = "<leader>as";
        action = "<cmd>ClaudeCodeSend<cr>";
        options.desc = "Claude: send selection";
      }
      {
        mode = "n";
        key = "<leader>ab";
        action = "<cmd>ClaudeCodeAdd %<cr>";
        options.desc = "Claude: add current file";
      }
      {
        mode = "n";
        key = "<leader>aa";
        action = "<cmd>ClaudeCodeDiffAccept<cr>";
        options.desc = "Claude: accept diff";
      }
      {
        mode = "n";
        key = "<leader>ad";
        action = "<cmd>ClaudeCodeDiffDeny<cr>";
        options.desc = "Claude: reject diff";
      }
      {
        mode = "n";
        key = "<leader>ai";
        action = "<cmd>ClaudeCodeStatus<cr>";
        options.desc = "Claude: connection status";
      }
    ];

    extraConfigLua = ''
      -- publish this nvim to the other tabs of its zellij session:
      -- $XDG_RUNTIME_DIR/zellij-dev/<session>/nvim.sock (lazygit's `e` opens files through it, see `zj-edit`)
      if vim.env.ZELLIJ_SESSION_NAME then
        local dir = (vim.env.XDG_RUNTIME_DIR or '/tmp') .. '/zellij-dev/' .. vim.env.ZELLIJ_SESSION_NAME
        local sock = dir .. '/nvim.sock'
        vim.fn.mkdir(dir, 'p')
        -- a live socket belongs to another nvim of this session; a dead one is a crash leftover
        local ok, chan = pcall(vim.fn.sockconnect, 'pipe', sock, { rpc = false })
        if ok and chan ~= 0 then
          vim.fn.chanclose(chan)
        else
          os.remove(sock)
          if pcall(vim.fn.serverstart, sock) then
            vim.api.nvim_create_autocmd('VimLeavePre', {
              callback = function()
                pcall(vim.fn.serverstop, sock)
                os.remove(sock)
              end,
            })
          end
        end

        -- after sending a selection to claude, switch to its tab to type the prompt
        vim.api.nvim_create_autocmd('User', {
          pattern = 'ClaudeCodeSendComplete',
          callback = function()
            vim.system({ 'zellij', 'action', 'go-to-tab-name', 'claude' })
          end,
        })
      end
    '';
  };
}
