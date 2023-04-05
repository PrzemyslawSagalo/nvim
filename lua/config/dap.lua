vim.keymap.set('n', '<leader>dc', require 'dap'.continue)
vim.keymap.set('n', '<leader>do', require 'dap'.step_over)
vim.keymap.set('n', '<leader>di', require 'dap'.step_into)
vim.keymap.set('n', '<leader>du', require 'dap'.step_out)
vim.keymap.set('n', '<leader>db', require 'dap'.toggle_breakpoint)
vim.keymap.set('n', '<leader>dt', require 'dap'.terminate)
vim.keymap.set('n', '<leader>dk', ":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")

vim.keymap.set('n', '<leader>dm', require 'dapui'.toggle)

local dap, dapui = require("dap"), require("dapui")

dapui.setup(
  {
    controls = {
      element = "repl",
      enabled = true,
      icons = {
        disconnect = "",
        pause = "",
        play = "",
        run_last = "",
        step_back = "",
        step_into = "",
        step_out = "",
        step_over = "",
        terminate = ""
      }
    },
    element_mappings = {},
    expand_lines = true,
    floating = {
      border = "single",
      mappings = {
        close = { "q", "<Esc>" }
      }
    },
    force_buffers = true,
    icons = {
      collapsed = "",
      current_frame = "",
      expanded = ""
    },
    layouts = { {
        elements = { {
            id = "breakpoints",
            size = 0.25
          }, {
            id = "watches",
            size = 0.5
          } },
        position = "left",
        size = 40
      }, {
        elements = { {
            id = "repl",
            size = 0.5
          }, {
            id = "scopes",
            size = 0.5
          } },
        position = "bottom",
        size = 10
      } },
    mappings = {
      edit = "e",
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      repl = "r",
      toggle = "t"
    },
    render = {
      indent = 1,
      max_value_lines = 100
    }
  }
)

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

