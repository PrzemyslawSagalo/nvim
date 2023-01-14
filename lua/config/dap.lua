vim.keymap.set('n', '<leader>c', require 'dap'.continue)
vim.keymap.set('n', '<leader>o', require 'dap'.step_over)
vim.keymap.set('n', '<leader>dsi', require 'dap'.step_into)
vim.keymap.set('n', '<leader>dso', require 'dap'.step_out)
vim.keymap.set('n', '<leader>db', require 'dap'.toggle_breakpoint)

local dap, dapui =require("dap"),require("dapui")
dap.listeners.after.event_initialized["dapui_config"]=function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"]=function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"]=function()
  dapui.close()
end

require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')
require("dapui").setup()
