-- Configuration for github/copilot.vim
-- Replicating keybindings from previous copilot.lua setup

-- Disable default <Tab> mapping
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true

-- Keybindings
local keymap = vim.keymap.set
-- Accept suggestion with <C-c>
keymap('i', '<C-c>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false,
  silent = true
})

-- Navigation and other actions
keymap('i', '<C-k>', '<Plug>(copilot-next)', { silent = true })
keymap('i', '<C-j>', '<Plug>(copilot-previous)', { silent = true })
keymap('i', '<C-w>', '<Plug>(copilot-accept-word)', { silent = true })
keymap('i', '<C-]>', '<Plug>(copilot-dismiss)', { silent = true })

-- Filetype Allowlist
vim.g.copilot_filetypes = {
  ["*"] = false,
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
}
