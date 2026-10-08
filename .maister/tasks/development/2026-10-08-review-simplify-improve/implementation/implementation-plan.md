## TL;DR
Refactor Neovim configuration to optimize lazy-loading, remove unused plugins, and standardize setups. Moves plugin-specific initialization from `init.lua` directly into `lazy.nvim` config specs, relocates core vim options out of the plugins folder, and removes deprecated/redundant plugins (`popup.nvim`, `tagbar`).

## Key Decisions
- Move plugin logic from `init.lua` to `lua/plugins/init.lua` inside `config` functions — Ensures lazy.nvim can appropriately lazy-load plugins.
- Merge Telescope extensions into `lua/plugins/configs/telescope.lua` — Prevents override breakage identified in the audit.
- Attach DAP config to `nvim-dap-ui` and use others as dependencies — Resolves 1-to-many plugin configuration ambiguity.
- Remove `opts = {}` when replacing with custom `config` — Prevents dead code and lazy.nvim override issues.

## Open Questions / Risks
- DAP dependencies loading order might require further adjustment if `nvim-dap-ui` fails to orchestrate the loading of `dap` and `mason-nvim-dap`.

## Overview
Total Steps: 19
Task Groups: 4
Expected Tests: 16-34

## Implementation Steps

### Task Group 1: Core Cleanups
**Dependencies:** None
**Files to Modify:** `init.lua`, `lua/plugins/configs/vim_options.lua`, `lua/core/vim_options.lua`, `lua/core/comment.lua`, `lua/core/general_keymaps.lua`, `tests/core_spec.lua`
**Estimated Steps:** 5

- [x] 1.0 Complete Core layer
  - [x] 1.1 Write 2-8 focused tests for core options and keymaps
    - Test only critical behaviors
    - Skip exhaustive coverage
  - [x] 1.2 Rename `lua/plugins/configs/vim_options.lua` to `lua/core/vim_options.lua`
    - Update `init.lua` to require `core.vim_options` instead of `plugins.configs.vim_options`
  - [x] 1.3 Remove `lua/core/comment.lua` and its `require` in `init.lua`
  - [x] 1.4 Clean up `lua/core/general_keymaps.lua`
    - Remove `<F8>` tagbar keymap (`TagbarToggle`)
    - Remove custom comment keymaps to favor Neovim's default `gc`
  - [x] 1.n Ensure Core layer tests pass
    - Run ONLY the 2-8 tests written in 1.1

**Acceptance Criteria:**
- The 2-8 tests pass
- `vim_options.lua` successfully moved to `lua/core/` and loaded in `init.lua`
- `comment.lua` deleted and no longer loaded
- `<F8>` Tagbar mapping removed from `general_keymaps.lua`

### Task Group 2: Plugin Pruning
**Dependencies:** 1
**Files to Modify:** `lua/plugins/init.lua`, `tests/plugins_spec.lua`
**Estimated Steps:** 4

- [x] 2.0 Complete Plugin Pruning layer
  - [x] 2.1 Write 2-8 focused tests for pruned plugins
    - Test that `tagbar` and `popup.nvim` are no longer loaded
  - [x] 2.2 Remove `preservim/tagbar` from `lua/plugins/init.lua`
  - [x] 2.3 Remove `nvim-lua/popup.nvim` from `lua/plugins/init.lua`
  - [x] 2.n Ensure Plugin Pruning layer tests pass
    - Run ONLY the 2-8 tests written in 2.1

**Acceptance Criteria:**
- The 2-8 tests pass
- `tagbar` and `popup.nvim` plugins removed from `lua/plugins/init.lua`

### Task Group 3: Lazy Loading Refactor
**Dependencies:** 1, 2
**Files to Modify:** `init.lua`, `lua/plugins/init.lua`, `lua/plugins/configs/telescope.lua`, `tests/lazy_spec.lua`
**Estimated Steps:** 5

- [x] 3.0 Complete Lazy Loading layer
  - [x] 3.1 Write 2-8 focused tests for lazy loading
    - Test that plugins lazily load and do not error on config invocation
  - [x] 3.2 Update `lua/plugins/init.lua` with custom `config` blocks
    - For plugins configured in `lua/plugins/configs/`, add `config = function() require("plugins.configs.<name>") end`
    - Remove redundant `opts = {}` entries when a custom `config` function is added
  - [x] 3.3 Apply Audit fixes for Telescope and DAP
    - Move `require("telescope").load_extension("live_grep_args")` from `lua/plugins/init.lua` into `lua/plugins/configs/telescope.lua`
    - Attach `config = function() require("plugins.configs.dap") end` specifically to `rcarriga/nvim-dap-ui` and list other DAP plugins as dependencies
  - [x] 3.4 Remove `require("plugins.configs.*")` block completely from `init.lua`
  - [x] 3.n Ensure Lazy Loading layer tests pass
    - Run ONLY the 2-8 tests written in 3.1

**Acceptance Criteria:**
- The 2-8 tests pass
- `init.lua` no longer contains `require("plugins.configs.*")` block
- Plugin specifications in `lua/plugins/init.lua` now use `config` functions
- Telescope `live_grep_args` logic moved correctly
- DAP config attached to `nvim-dap-ui` with correct dependencies

### Task Group 4: Test Review & Gap Analysis
**Dependencies:** All previous groups
**Files to Modify:** `tests/**/*_spec.lua`
**Estimated Steps:** 5

- [x] 4.0 Review and fill critical gaps
  - [x] 4.1 Review tests from previous groups (6-24 existing tests)
  - [x] 4.2 Analyze gaps for THIS feature only
  - [x] 4.3 Write up to 10 additional strategic tests
  - [x] 4.4 Run feature-specific tests only (expect 16-34 total)

**Acceptance Criteria:**
- All feature tests pass (~16-34 total)
- No more than 10 additional tests added

## Execution Order

1. Group 1 (5 steps)
2. Group 2 (4 steps, depends on 1)
3. Group 3 (5 steps, depends on 1, 2)
4. Group 4 (5 steps, depends on 1, 2, 3)

## Standards Compliance

Follow standards from `.maister/docs/standards/`:
- global/ - Always applicable
- neovim/ - Area-specific configuration and lua conventions

## Notes

- Test-Driven: Each group starts with 2-8 tests
- Run Incrementally: Only new tests after each group
- Mark Progress: Check off steps as completed
- Reuse First: Prioritize existing components from spec
