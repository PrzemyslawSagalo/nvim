local status_ok, aerial = pcall(require, "aerial")

if not status_ok then
  return
end

aerial.setup({
  -- Priority of backends. If one fails or isn't available, it moves to the next.
  -- Treesitter is currently having issues on Nvim 0.12 dev.
  backends = { "lsp", "treesitter", "markdown", "man" },
  on_attach = function(bufnr)
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,
})

vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")
