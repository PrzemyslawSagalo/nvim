local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
    return
end

local status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok then
    return
end

mason_lspconfig.setup({
    ensure_installed = {
      'lua_ls',
      'pyright',
      'clangd',
      'biome'
    }
})

local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

mason_lspconfig.setup_handlers({
  function(server_name)
    lspconfig[server_name].setup({
      capabilities = lsp_capabilities,
    })
  end,
})

--local capabilities = vim.lsp.protocol.make_client_capabilities()
--lspconfig.pyright.setup({
--    capabilities = capabilities,
--    filetype = {"python"}
--})
