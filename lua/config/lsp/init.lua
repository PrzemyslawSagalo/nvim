local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  print("pacll lspconfig went wrong")
  return
end

require "config.lsp.mason"
require("config.lsp.handlers").setup()
require "config.lsp.null-ls"
