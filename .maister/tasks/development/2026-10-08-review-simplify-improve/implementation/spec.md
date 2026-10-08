## TL;DR
Refactor Neovim configuration to optimize lazy-loading, remove unused plugins, and standardize setups. Moves plugin-specific initialization from `init.lua` directly into `lazy.nvim` config specs, relocates core vim options out of the plugins folder, and removes deprecated/redundant plugins (`popup.nvim`, `tagbar`).

## Key Decisions
- Move plugin config requirements from `init.lua` to `lua/plugins/init.lua` (within `config` functions) — ensures `lazy.nvim` can appropriately lazy-load plugins.
- Relocate `plugins.configs.vim_options` to `core.vim_options` — logical separation of core Neovim options and plugin configurations.
- Remove `preservim/tagbar` — redundant as `stevearc/aerial.nvim` is installed and provides better, tree-sitter based structural visualization.
- Remove `nvim-lua/popup.nvim` — deprecated legacy plugin superseded by `plenary.nvim`.
- Remove `lua/core/comment.lua` — use Neovim 0.10+ native `gc` commenting to drop unnecessary custom logic.

## Open Questions / Risks

## Goal
Clean up the Neovim configuration by eliminating redundant plugins, optimizing lazy-loading through correct Lazy.nvim integration, and standardizing the configuration structure.

## Core Requirements
1. **Lazy Loading Optimization**: Remove all unconditional `require("plugins.configs.*")` calls from `init.lua` and integrate them into `lua/plugins/init.lua` using the `config` key for their respective plugins.
2. **Configuration Standardization**: Move `lua/plugins/configs/vim_options.lua` to `lua/core/vim_options.lua` and require it early in `init.lua`.
3. **Plugin Cleanup**: Uninstall `preservim/tagbar` and `nvim-lua/popup.nvim`. Remove `TagbarToggle` keymap from `lua/core/general_keymaps.lua`.
4. **Custom Script Simplification**: Delete `lua/core/comment.lua` and its require statement in `init.lua`. Remove custom commenting keymaps in favor of Neovim's default `gc` commenting.

## Reusable Components
### Existing Code to Leverage
- `lazy.nvim` setup in `lua/plugins/init.lua` can natively accept the existing `plugins.configs.*` scripts via the `config` function.
- `stevearc/aerial.nvim` fully replaces the need for `tagbar`.

### New Components Required
- None. This is a refactoring and simplification task.

## Technical Approach
1. **Move Options**: Rename `lua/plugins/configs/vim_options.lua` to `lua/core/vim_options.lua`. Update `init.lua` to require `core.vim_options` instead.
2. **Fix Lazy Loading**: Edit `lua/plugins/init.lua`. For plugins that have configurations in `lua/plugins/configs/`, add a `config = function() require("plugins.configs.<name>") end` block.
3. **Cleanup init.lua**: Remove the block of `require("plugins.configs.*")` from `init.lua`.
4. **Remove Unused Plugins/Scripts**:
   - Delete `lua/core/comment.lua`.
   - Remove `require("core.comment")` from `init.lua`.
   - Remove `popup.nvim` and `tagbar` from `lua/plugins/init.lua`.
   - Remove `<F8>` tagbar keymap from `lua/core/general_keymaps.lua`.

## Implementation Guidance
### Testing Approach
- Verify Neovim starts without errors.
- Verify lazy-loaded plugins load correctly upon their triggers.
- Verify `core.vim_options` is applied correctly at startup.

### Standards Compliance
- Adheres to standard `lazy.nvim` configuration practices.
- Maintains separation of concerns (`core` vs `plugins`).

## Out of Scope
- Adding new plugins or features.
- Changing the colorscheme or specific plugin behaviors (unless required for lazy-loading).

## Success Criteria
- Neovim starts without any Lua errors.
- `lazy.nvim` correctly reports plugins as lazy-loaded instead of loaded on startup.
- `init.lua` is clean and does not bypass the plugin manager.
- Deprecated plugins and redundant custom scripts are entirely removed.
