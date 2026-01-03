require("mason-nvim-dap").setup({
    ensure_installed = { "python", "kotlin" },
    automatic_installation = true,
})

local keymap = vim.api.nvim_set_keymap

local opts = {noremap = true, silent = true}

keymap('n', '<leader>dc', ":lua require('dap').continue()<CR>", opts)
keymap('n', '<leader>do', ":lua require('dap').step_over()<CR>", opts)
keymap('n', '<leader>di', ":lua require('dap').step_into()<CR>", opts)
keymap('n', '<leader>du', ":lua require('dap').step_out()<CR>", opts)
keymap('n', '<leader>db', ":lua require('dap').toggle_breakpoint()<CR>", opts)
keymap('n', '<leader>dt', ":lua require('dap').terminate()<CR>", opts)
keymap('n', '<leader>dk', ":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opts)
keymap('n', '<leader>dm', ":lua require('dapui').toggle()<CR>", opts)

-- Floating window
local screen_width = vim.o.columns
local screen_height = vim.o.lines
local floating_window_width = math.floor(screen_width * 0.9)
local floating_window_height = math.floor(screen_height * 0.9)
keymap('n', '<leader>df', string.format(":lua require('dapui').float_element(nil, {width = %s, height = %s, enter = true, position = 'center'})<CR>", floating_window_width, floating_window_height), opts)

local dap, dapui = require("dap"), require("dapui")

dapui.setup({
    controls = {
        element = "repl",
        enabled = true
    },
    element_mappings = {},
    expand_lines = true,
    floating = {border = "single", mappings = {close = {"q", "<Esc>"}}},
    force_buffers = true,
    icons = {collapsed = "", current_frame = "", expanded = ""},
    layouts = {
        {
            elements = {
                {id = "watches", size = 0.5},
                {id = "scopes", size = 0.5}
            },
            position = "left",
            size = 40
        },
        {elements = {{id = "repl", size = 1}}, position = "bottom", size = 10}
    },
    mappings = {
        edit = "e",
        expand = {"<CR>", "<2-LeftMouse>"},
        open = "o",
        remove = "d",
        repl = "r",
        toggle = "t"
    },
    render = {indent = 1, max_value_lines = 100}
})

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end

function _G.load_project_dap_config()
  local dap_config_path = vim.fn.getcwd() .. '/dap_config.lua'
  if vim.fn.filereadable(dap_config_path) == 1 then
    vim.cmd('luafile ' .. dap_config_path)
    -- Using vim.notify instead of print for a more robust message
    vim.notify('Loaded project-specific DAP configuration', vim.log.levels.INFO, { title = 'DAP' })
  end
end

---
-- Autocommand setup for DAP project config
---

-- Create a dedicated augroup to ensure commands are not duplicated on reload
local dap_project_group = vim.api.nvim_create_augroup('DapProjectConfig', { clear = true })

-- It loads the config when you open a relevant file.
vim.api.nvim_create_autocmd('FileType', {
  group = dap_project_group,
  pattern = { 'python', 'cpp', 'kotlin' }, -- Add any other filetypes here
  desc = 'Load project DAP config on file open',
  callback = function()
    if _G.load_project_dap_config then
      _G.load_project_dap_config()
    end
  end,
})

-- It reloads the config when you SAVE the config file itself.
vim.api.nvim_create_autocmd('BufWritePost', {
  group = dap_project_group,
  pattern = '*/dap_config.lua', -- Matches the config file in any directory
  desc = 'Reload project-specific DAP config on save',
  callback = function()
    local ok, err = pcall(function()
      if _G.load_project_dap_config then
        _G.load_project_dap_config()
      else
        vim.notify('DAP: _G.load_project_dap_config function not found', vim.log.levels.WARN)
      end
    end)

    if not ok then
      vim.notify('Failed to reload project DAP config: ' .. tostring(err), vim.log.levels.ERROR)
    end
  end,
})
