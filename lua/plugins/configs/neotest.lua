local python_utils = require("utils.python_utils")

require("neotest").setup({
    adapters = {
        require("neotest-python")({
		runner = "pytest",
        python = python_utils.python_interpreter_path(),
		dap = { justMyCode = false},
	}),
    }
})

local keymap = vim.api.nvim_set_keymap

local opts = {noremap = true, silent = true}

keymap("n", "<leader>tc", ':lua require("neotest").run.run()<CR>', opts)
keymap("n", "<leader>tf", ':lua require("neotest").run.run(vim.fn.expand("%"))<CR>', opts)
keymap("n", "<leader>ta", ':lua require("neotest").run.run(vim.fn.expand("."))<CR>', opts)
keymap("n", "<leader>td", ':lua require("neotest").run.run({strategy = "dap"})<CR>', opts)
keymap("n", "<leader>ts", ':lua require("neotest").run.stop()<CR>', opts)
keymap("n", "<leader>tm", ':lua require("neotest").summary.toggle()<CR>:lua require("neotest").output_panel.toggle()<CR>', opts)
