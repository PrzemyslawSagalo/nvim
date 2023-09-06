local status_ok, cmp = pcall(require, "cmp")
if not status_ok then return end

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end
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
            select = true
        })
    },
    sources = {{name = 'nvim_lsp'}, {name = "vsnip"}, {name = "buffer"}}
})

local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then return end

local status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok then return end

local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
mason_lspconfig.setup({ensure_installed = {'lua_ls', 'pyright', 'clangd'}})

lspconfig.lua_ls.setup({
    capabilities = lsp_capabilities,
    on_attach = function(client, bufnr)
        require('lsp_signature').on_attach()
    end
})

lspconfig.pyright.setup({
    capabilities = lsp_capabilities,
    on_attach = function(client, bufnr)
        require('lsp_signature').on_attach()
    end
})

lspconfig.clangd.setup({capabilities = lsp_capabilities})

