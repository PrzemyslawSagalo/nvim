require("neotest").setup({
  adapters = {
    require("neotest-python")({
      dap = { justMyCode = false },
    }),
    require("neotest-plenary"),
    require("neotest-vim-test")({
      ignore_file_types = { "python", "vim", "lua" },
    }),
  },
})

vim.keymap.set("n", "<leader>tm", ':lua require("neotest").run.run()<CR>')
vim.keymap.set("n", "<leader>tf", ':lua require("neotest").run.run(vim.fn.expand("%"))<CR>')
vim.keymap.set("n", "<leader>ta", ':lua require("neotest").run.run(vim.fn.expand("."))<CR>')
vim.keymap.set("n", "<leader>td", ':lua require("neotest").run.run({strategy = "dap"})<CR>')
vim.keymap.set("n", "<leader>ts", ':lua require("neotest").run.stop()<CR>')
vim.keymap.set("n", "<leader>tt", ':lua require("neotest").summary.toggle()<CR>:lua require("neotest").output_panel.toggle()<CR>')

