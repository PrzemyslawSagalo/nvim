-- This configuration is deprecated as it is not possible to pass more then oneource dir like src or tests
require("neotest").setup({
    adapters = {
        require("neotest-python")({dap = {justMyCode = false}}),
    }
})

vim.keymap.set("n", "<leader>tc", ':lua require("neotest").run.run()<CR>')
vim.keymap.set("n", "<leader>tf",
               ':lua require("neotest").run.run(vim.fn.expand("%"))<CR>')
vim.keymap.set("n", "<leader>ta",
               ':lua require("neotest").run.run(vim.fn.expand("."))<CR>')
vim.keymap.set("n", "<leader>td",
               ':lua require("neotest").run.run({strategy = "dap"})<CR>')
vim.keymap.set("n", "<leader>ts", ':lua require("neotest").run.stop()<CR>')
vim.keymap.set("n", "<leader>tm",
               ':lua require("neotest").summary.toggle()<CR>:lua require("neotest").output_panel.toggle()<CR>')
