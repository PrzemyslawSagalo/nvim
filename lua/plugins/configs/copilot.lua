vim.g.copilot_filetypes = {
    ["*"] = false,
    lua = true,
    python = true,
    html = true,
    markdown = true,
    json = true,
    yaml = true,
    sh = true,
    zsh = true,
    bash = true,
    vim = true,
    go = true,
    rust = true,
    c = true,
    cpp = true,
    kotlin = true,
    sql = true,
    yaml = true
}

vim.cmd [[highlight CopilotSuggestion guifg=#555555 ctermfg=8]]

vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.api.nvim_set_keymap("i", "<C-a>", 'copilot#Accept("<CR>")',
                        {silent = true, expr = true})
