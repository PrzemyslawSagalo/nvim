return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main", -- STRICTLY for Nvim v0.12+
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local install = require("nvim-treesitter.install")
      
      -- Force build using system tools
      install.prefer_git = true
      install.compilers = { "gcc" }

      local status_ok, configs = pcall(require, "nvim-treesitter.configs")
      if not status_ok then
        return
      end

      configs.setup({
        ensure_installed = {
          "bash",
          "c",
          "cpp",
          "json",
          "lua",
          "make",
          "python",
          "rst",
          "yaml",
        },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
      })
    end,
  },
}
