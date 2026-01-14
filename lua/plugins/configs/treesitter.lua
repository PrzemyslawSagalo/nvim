return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main", -- STRICTLY for Nvim v0.12+
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- If we ran this code outside this function, Neovim would crash on startup
      -- because 'nvim-treesitter' wouldn't be loaded yet.
      require("nvim-treesitter").install({
        "bash",
        "c",
        "cpp",
        "dockerfile",
        "groovy",
        "json",
        "kotlin",
        "lua",
        "make",
        "python",
        "rst",
        "sql",
        "vim",
        "yaml",
      })
    end,
  },
}
