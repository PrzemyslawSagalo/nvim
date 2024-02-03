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
keymap('n', '<leader>df', string.format(":lua require('dapui').float_element(nil, {width = %s, height = %s, enter = true, position = 'center})<CR>", floating_window_width, floating_window_height), opts)

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
        print('Loaded project-specific DAP configuration')
    end
end

vim.cmd([[autocmd FileType python,cpp lua load_project_dap_config()]])

