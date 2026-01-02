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

vim.cmd [[highlight CopilotSuggestion guifg=#555555 ctermfg=8]]

vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true

vim.keymap.set('i', '<C-c>', 'copilot#Accept("<CR>")', {
    expr = true,
    replace_keycodes = false,
    remap = true
})
vim.keymap.set('i', '<C-w>', '<Plug>(copilot-accept-word)')
vim.keymap.set('i', '<C-j>', '<Plug>(copilot-previous)')
vim.keymap.set('i', '<C-k>', '<Plug>(copilot-next)')

