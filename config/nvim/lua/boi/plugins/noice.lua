return {
  -- Noice.nvim: Better UI for messages and LSP
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim', -- Required
      'rcarriga/nvim-notify', -- Optional, better notifications
    },
    config = function()
      require('noice').setup {
        lsp = {
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true, -- needs nvim-cmp
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = false,
        },
      }
    end,
  },

  -- Optional: Use Notify for Noice messages

  {
    'rcarriga/nvim-notify',
    lazy = true,
    config = function()
      local notify = require 'notify'

      -- Set as global notify function
      vim.notify = notify

      -- Optional: configure notify appearance
      notify.setup {
        background_colour = '#000000', -- ← your preferred color here
      }
    end,
  },
}
