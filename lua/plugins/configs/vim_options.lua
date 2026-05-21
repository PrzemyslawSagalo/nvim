vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.errorbells = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.smartindent = true

vim.opt.wrap = false

-- Hyper-fast autoread configuration
vim.opt.autoread = true
vim.opt.updatetime = 200

local autoread_group = vim.api.nvim_create_augroup("HyperFastAutoread", { clear = true })

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorMoved" }, {
	group = autoread_group,
	desc = "Synchronize file state with disk on focus and movement",
	callback = function()
		if vim.api.nvim_get_mode().mode ~= "c" then
			vim.cmd("checktime")
		end
	end,
})
