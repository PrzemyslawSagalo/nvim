return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main", -- STRICTLY for Nvim v0.12+
    lazy = false,
    build = ":TSUpdate",
    config = function()
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
        -- Automatically install missing parsers when entering buffer
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
      })
      -- If tree-sitter CLI is missing, we can try to force use of git
      require("nvim-treesitter.install").prefer_git = true
    end,
  },
}
