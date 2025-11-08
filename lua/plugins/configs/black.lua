local function black_format()
    local bufnr = vim.api.nvim_get_current_buf()
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    local success, _ = pcall(vim.fn.system, {"black", bufname})
    if success then
        vim.api.nvim_command("checktime")
    else
        vim.api.nvim_echo({{"Error formatting with Black", "ErrorMsg"}}, true,
                          {})
    end
end

return {black_format = black_format}

