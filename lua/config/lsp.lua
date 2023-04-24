-- Reserve space for diagnostic icons
vim.opt.signcolumn = 'yes'

local lsp = require('lsp-zero')
lsp.preset('recommended')

lsp.ensure_installed({
  'lua_ls',
  'pyright',
  'clangd'
})

lsp.nvim_workspace()

lsp.setup()
