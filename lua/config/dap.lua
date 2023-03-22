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

function _G.load_project_dap_config()
  local dap_config_path = vim.fn.getcwd() .. '/dap_config.lua'
  if vim.fn.filereadable(dap_config_path) == 1 then
    vim.cmd('luafile ' .. dap_config_path)
    print('Loaded project-specific DAP configuration')
  end
end

vim.cmd([[autocmd FileType python lua load_project_dap_config()]])

require("dapui").setup()
