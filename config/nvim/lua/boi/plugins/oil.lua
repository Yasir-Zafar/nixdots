return {
  -- Oil.nvim: File explorer in buffer
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cmd = 'Oil', -- Lazy load on :Oil command
    keys = {
      { '-', '<CMD>Oil<CR>', desc = 'Open Oil file explorer' },
    },
    opts = {
      default_file_explorer = true,
      view_options = {
        show_hidden = true,
      },
    },
  },
}
