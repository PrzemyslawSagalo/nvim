vim.keymap.set('n', '<leader>c', require 'dap'.continue)
vim.keymap.set('n', '<leader>o', require 'dap'.step_over)
vim.keymap.set('n', '<leader>dsi', require 'dap'.step_into)
vim.keymap.set('n', '<leader>dso', require 'dap'.step_out)
vim.keymap.set('n', '<leader>db', require 'dap'.toggle_breakpoint)

vim.keymap.set('n', '<leader>dm', require 'dapui'.toggle)

local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"]=function()
  dapui.open()
end

require('dap-python').setup('~/venv/bin/python')
require("dapui").setup()
