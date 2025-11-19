require('dotenv').setup({
  enable_on_load = true, -- will load your .env file upon loading a buffer
  verbose = true, -- show error notification if .env file is not found and if .env is loaded
})

local status, dotenv = pcall(require, "dotenv")

if not status then
  vim.notify("Dotenv plugin not found. Skipping.", vim.log.levels.WARN)
else
  dotenv.setup({
    enable_on_load = true,
    verbose = false
  })
end
