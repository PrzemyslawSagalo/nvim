return {
  {
    "https://codeberg.org/andyg/leap.nvim",
    lazy = false,
    dependencies = {
      "tpope/vim-repeat",
    },
    config = function()
      local leap = require("leap")

      -- Explicitly set the correct mapping targets
      vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap-forward)', { silent = true, desc = 'Leap forward' })
      vim.keymap.set({'n', 'x', 'o'}, 'S', '<Plug>(leap-backward)', { silent = true, desc = 'Leap backward' })
      vim.keymap.set({'n', 'x', 'o'}, 'gs', '<Plug>(leap-from-window)', { silent = true, desc = 'Leap from window' })
    end,
  },
}
