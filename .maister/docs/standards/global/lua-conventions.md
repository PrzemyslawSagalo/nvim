# Lua Conventions

### Configuration Structure
- Use `init.lua` as the main entry point.
- Group plugin configurations into the `lua/` directory to be lazy-loaded by `lazy.nvim`.

### Options and Globals
- Set Neovim options using `vim.opt` rather than `vim.cmd` or raw vimscript.
- Define global variables using `vim.g`.

### Plugin Management
- Use `lazy.nvim` for all plugin declarations.
- Specify dependencies directly in plugin specs.
