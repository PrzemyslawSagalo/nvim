local status_cmp, cmp = pcall(require, "cmp")
if not status_cmp then return end

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = {
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        }),
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "vsnip" },
        { name = "buffer" },
    },
})

local status_lsp, lspconfig = pcall(require, "lspconfig")
if not status_lsp then return end

local status_mason, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_mason then return end

local status_cmp_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_lsp then return end

local lsp_capabilities = cmp_nvim_lsp.default_capabilities()

local on_attach = function(client, bufnr)
    local status_sig, lsp_signature = pcall(require, "lsp_signature")
    if status_sig then
        lsp_signature.on_attach()
    end
end

mason_lspconfig.setup({
    ensure_installed = {
        "marksman",
        "bashls",
        "clangd",
        "lua_ls",
        "ruff",
    },
    handlers = {
        function(server_name)
            lspconfig[server_name].setup({
                capabilities = lsp_capabilities,
                on_attach = on_attach,
            })
        end,
    },
})

vim.diagnostic.config({
    virtual_text = {
        severity = { min = vim.diagnostic.severity.HINT },
    },
    signs = {
        severity = { min = vim.diagnostic.severity.HINT },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { fg = "#808080", undercurl = true, default = true })
