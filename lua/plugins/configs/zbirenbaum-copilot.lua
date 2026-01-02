return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    build = ":Copilot auth",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = "<C-c>",
          accept_word = "<C-w>",
          -- Disable accept_line as it wasn't in your config
          accept_line = false,
          next = "<C-k>",
          prev = "<C-j>",
          dismiss = "<C-]>",
        },
      },
      panel = { enabled = false },
      -- Replicating your "Allowlist" strategy
      filetypes = {
        ["*"] = false, -- Disable by default for all files
        bash = true,
        c = true,
        cpp = true,
        go = true,
        groovy = true,
        html = true,
        json = true,
        kotlin = true,
        lua = true,
        markdown = true,
        python = true,
        rst = true,
        rust = true,
        sh = true,
        sql = true,
        vim = true,
        yaml = true,
        zsh = true,
      },
    },
    config = function(_, opts)
      require("copilot").setup(opts)
      -- Apply your custom highlight color (#555555)
      -- We force this to ensure it overrides the theme defaults
      vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = "#555555", ctermfg = 8, force = true })
    end,
  },
}

