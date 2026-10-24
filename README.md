# NVIM CONFIGURATION

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Personal Neovim configuration built for modern development, structured testing, and extensible plugin management.

## Architectural Drivers
* Standalone repository for rapid iteration: change, test, and push.
* Modular plugin architecture managed via [lazy.nvim](https://github.com/folke/lazy.nvim).
* Automated headless specification and unit tests for plugins and keymaps.

## Repository Structure
* `init.lua` - Main initialization script configuring settings, core options, and lazy-loading.
* `lua/core/` - Core options, key mappings, and autocmds.
* `lua/plugins/` - Modular plugin specifications.
* `tests/` - Headless Neovim test harnesses validating plugin specifications and contracts.

## Terminal & Tmux Integration

When running Neovim inside tmux, terminal multiplexers suppress focus event escape sequences by default. To enable automatic buffer reload (`FocusGained`) when switching between tmux panes and windows, ensure focus events are enabled in your `~/.tmux.conf`:

```tmux
# Enable focus event reporting for terminal focus tracking in Neovim
set -g focus-events on
```

Reload tmux configuration with `tmux source-file ~/.tmux.conf` or `prefix + r`.

## Cheat Sheet & Keymaps Reference
General Vim shortcuts, search & substitution patterns, multi-buffer commands, sorting flags, and plugin keybindings have been migrated to Vergilii:
* [Vergilii - Vim / Neovim Cheat Sheet](https://github.com/PrzemyslawSagalo/vergilii/blob/main/cheat_sheets/vim.md)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
