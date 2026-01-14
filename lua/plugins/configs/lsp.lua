local status_cmp, cmp = pcall(require, "cmp")
if not status_cmp then return end

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end
    },
    mapping = {
        ["<C-k>"] = cmp.mapping.select_prev_item(), -- Move up
        ["<C-j>"] = cmp.mapping.select_next_item(), -- Move down
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),    -- Scroll info window up
        ["<C-f>"] = cmp.mapping.scroll_docs(4),     -- Scroll info window down
        ["<C-Space>"] = cmp.mapping.complete(),     -- Force trigger completion
        ["<C-e>"] = cmp.mapping.close(),            -- Close completion window
        ["<CR>"] = cmp.mapping.confirm({            -- Enter to confirm selection
            behavior = cmp.ConfirmBehavior.Insert,
            select = true
        })
    },
    -- Sources: Where the completion data comes from (LSP, snippets, current file buffer).
    sources = {
        { name = 'nvim_lsp' },
        { name = "vsnip" },
        { name = "buffer" }
    }
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
        'bashls',
        'clangd',
        'lua_ls',
        'pyright',
    },
    handlers = {
        function(server_name)
            lspconfig[server_name].setup({
                capabilities = lsp_capabilities,
                on_attach = on_attach,
            })
        end,
    }
})
