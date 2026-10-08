# Technology Stack

## Overview
This document describes the technology choices and rationale for this Neovim Configuration (dotfiles).

## Languages

### Lua (5.1/JIT)
- **Usage**: Primary configuration language
- **Rationale**: Lua is the first-class language for Neovim configuration and plugin development, offering high performance via LuaJIT.
- **Key Features Used**: Tables, metamethods, module system.

## Frameworks

### Package Management
- **lazy.nvim**: Modern, fast, and feature-rich plugin manager for Neovim.
- **Rationale**: Provides lazy-loading, dependency management, and an excellent UI for managing Neovim plugins.

### Testing
- [No testing frameworks detected]

## Build Tools & Package Management
- **lazy.nvim** handles plugin installation and updates.

## Development Tools

### Linting & Formatting
- Typically uses stylua, selene, or luacheck (to be configured).

### Type Checking
- Typically uses lua-language-server (to be configured).

## Key Dependencies
- Neovim (0.9+)
- Various Neovim plugins defined in `lua/` and `init.lua`.

---
*Last Updated*: 2026-10-08
*Auto-detected*: Lua language, lazy.nvim plugin manager.
