vim.keymap.set('n', '<leader>dc', require 'dap'.continue)
vim.keymap.set('n', '<leader>do', require 'dap'.step_over)
vim.keymap.set('n', '<leader>di', require 'dap'.step_into)
vim.keymap.set('n', '<leader>du', require 'dap'.step_out)
vim.keymap.set('n', '<leader>db', require 'dap'.toggle_breakpoint)
vim.keymap.set('n', '<leader>dt', require 'dap'.terminate)

vim.keymap.set('n', '<leader>dm', require 'dapui'.toggle)

local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"]=function()
  dapui.open()
end

require('dap-python').setup('~/venv/bin/python')
require('dap-python').test_runner = 'pytest'
require("dapui").setup()
