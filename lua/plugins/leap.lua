return {
  {
    "https://codeberg.org/andyg/leap.nvim",
    lazy = false,
    dependencies = {
      "tpope/vim-repeat",
    },
    config = function()
      local status_ok, leap = pcall(require, "leap")
      if not status_ok then
        -- fallback silently if require fails
        return
      end

      -- Explicitly set the correct mapping targets
      vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap-forward)', { silent = true, desc = 'Leap forward' })
      vim.keymap.set({'n', 'x', 'o'}, 'S', '<Plug>(leap-backward)', { silent = true, desc = 'Leap backward' })
      vim.keymap.set({'n', 'x', 'o'}, 'gs', '<Plug>(leap-from-window)', { silent = true, desc = 'Leap from window' })
    end,
  },
}
