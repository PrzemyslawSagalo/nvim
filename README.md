# NVIM CONFIGURATION

## Architectural drivers
* This is a standalone repository as it gives the possibility to: change, test and push.

## DAP Python
```
import pandas as pd; pd.set_option("display.max_rows", 999999); pd.set_option("display.max_columns", 999999); pd.set_option("display.max_colwidth", 999999)
```

# NVIM shortcuts
## General
| Key                      | Action                                        |
|--------------------------|-----------------------------------------------|
| `"+y`                    | copy to OS clipboard                          |
| `:norm A  [ sign to put]`| put a sign at the end of a line               |
| `:verbose imap <key>`    | show which plugin mapped a key in insert mode |
| `:verbose nmap <key>`    | show which plugin mapped a key in normal mode |

## Basic word navigation
- `w` - Move the cursor to the **beginning** of the **next** word.
- `b` - Move the cursor to the **beginning** of the **current** or **previous** word.
- `e` - Move the cursor to the **end** of the **current** or **next** word.

## Substitution
### Single file
```
:[range]s/search/replace/[flags]
```

- `range`: (optional) a range of lines to apply the substitution, e.g., `1,5s` for lines 1 to 5, `.,+10s` for lines from current to 10 down, `%` for the entire file.
- `search`: the string or pattern you want to search for.
- `replace`: the string you want to replace the search string with.
- `flags`: (optional) one or more flags to modify the behaviour of the substitution, e.g., `g` for global (replace all occurrences in the specified range), `i` for case-insensitive search, `c` for confirming each substitution.

### All buffors
```
:bufdo %s/ad_endpoint/active_directory/gce | update
```

- `:bufdo`: Execute the following command in every buffer in the buffer list
- `gce`: Flags: g - replace all occurrences in each line (global); c - confirm each substitution; e - suppress errors (if pattern not found in some buffers)
- `update`: Save the file only if it has been modified   

## LSP
| Key        | Action                   | 
|------------|--------------------------|
| `:LspInfo` | status of the lsp server |

## nvim-tree

| Key       | Action            | Description                                                       |
|-----------|-------------------|-------------------------------------------------------------------|
| `<CR>`    | edit              | open a file or folder; root will cd to the above directory        |
| `<C-v>`   | vsplit            | open the file in a vertical split                                 |
| `<C-x>`   | split             | open the file in a horizontal split                               |
| `<C-t>`   | tabnew            | open the file in a new tab                                        |
| `<`       | prev_sibling      | navigate to the previous sibling of current file/directory        |
| `>`       | next_sibling      | navigate to the next sibling of current file/directory            |
| `P`       | parent_node       | move cursor to the parent directory                               |
| `<BS>`    | close_node        | close current opened directory or parent                          |
| `<Tab>`   | preview           | open the file as a preview (keeps the cursor in the tree)         |
| `R`       | refresh           | refresh the tree                                                  |
| `a`       | create            | add a file; leaving a trailing `/` will add a directory           |
| `d`       | remove            | delete a file (will prompt for confirmation)                      |
| `D`       | trash             | trash a file via |trash| option                                   |
| `r`       | rename            | rename a file                                                     |
| `<C-r>`   | full_rename       | rename a file and omit the filename on input                      |
| `e`       | rename_basename   | rename a file with filename-modifiers ':t:r' without changing extension |
| `x`       | cut               | add/remove file/directory to cut clipboard                        |
| `c`       | copy              | add/remove file/directory to copy clipboard                       |
| `p`       | paste             | paste from clipboard; cut clipboard has precedence over copy; will prompt for confirmation |
| `y`       | copy_name         | copy name to system clipboard                                     |
| `Y`       | copy_path         | copy relative path to system clipboard                            |
| `gy`      | copy_absolute_path| copy absolute path to system clipboard                            |
| `s`       | system_open       | open a file with default system application or a folder with default file manager, using |system_open| option |

## Buffers, Windows and Tabs

### Buffers
Buffers are in-memory representations of files. When you open a file in Neovim, it is loaded into a buffer.

### Windows
Windows are views into buffers. You can have multiple windows open at once.

### Tabs
Tabs are collections of windows. Each tab can have multiple windows open.

| Key                    | Action                                 |
|------------------------|----------------------------------------|
| `gt`                   | next tab                               |
| `gT`                   | previous tab                           |
| `<S-l>`                | next buffer                            |
| `<S-h>`                | previous buffer                        |
| `:bwipeout` or `:bw`   | delete and remove a buffer from a list |

## surround

| Key                                | Action              |
|------------------------------------|---------------------|
| `ys<motion><delimiter>`            | you surround/add    |
| `cs<old delimiter><new delimiter>` | change surrounding  |
| `ds<delimiter>`                    | delete surrounding  |

## treesj

[Commands](https://github.com/Wansmer/treesj?tab=readme-ov-file#commands)

## Telescope
`:Telescope keymaps`

## sort

### Basic Syntax

The general form of the command is: `:[range]sort[!] [options] [/{pattern}/]`

---

### Ranges

| Command | Description |
| :--- | :--- |
| `:%sort` | Sort the entire file. |
| `:10,20sort` | Sort lines 10 through 20. |
| `:'<,'>sort` | Sort the current visual selection (automatically entered after selecting). |
| `:.,+5sort` | Sort from the current line to 5 lines down. |

---

### Common Flags

Flags can be combined (e.g., `nu` for numeric unique sort).

| Flag | Description | Example |
| :--- | :--- | :--- |
| `!` or `r` | **R**everse the sort order. | `:%sort!` |
| `u` | **U**nique: remove duplicate lines. | `:%sort u` |
| `n` | **N**umeric: sort based on the first decimal number in the line. | `:%sort n` |
| `i` | **I**gnore case. | `:%sort i` |
| `f` | **F**old case: similar to `i` but respects the `'ignorecase'` setting. | `:%sort f` |
| `x` | Sort based on the first he**x**adecimal number. | `:%sort x` |
| `o` | Sort based on the first **o**ctal number. | `:%sort o` |
| `b` | Sort based on the first **b**inary number. | `:%sort b` |

### Combining Flags
```vim
" Reverse, numeric, unique sort
:%sort! nu

" Case-insensitive unique sort
:%sort ui
```

## Difftastic Integration

Structural, syntax-aware AST diff viewer powered by [Difftastic](https://github.com/Wilfred/difftastic) with both side-by-side buffer splits and zero-overhead floating terminal inspectors.

### Requirements
- **Difftastic CLI**: `difft` executable installed in `$PATH` (`brew install difftastic` or `cargo install --locked difftastic`).
- **Neovim**: Version `>= 0.10` (recommended: `>= 0.11`).
- **Dependencies**:
  - `MunifTanjim/nui.nvim` (UI components)
  - `folke/snacks.nvim` (Commit/revision picker integration)

### Installation
Add the plugin spec to your `lazy.nvim` plugin directory (e.g., `lua/plugins/difftastic.lua`):

```lua
return {
  {
    "clabby/difftastic.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "folke/snacks.nvim" },
    -- Spec automatically configured in lua/plugins/difftastic.lua
  }
}
```

### Commands and Keymaps

| Keymap | Mode | Action | Scope / Target |
| :--- | :--- | :--- | :--- |
| `<leader>gd` | Normal | Floating Review | Working tree (unstaged modifications) |
| `<leader>gD` | Normal | Floating Review | Staged changes (`git diff --staged`) |
| `<leader>gf` | Normal | Floating Review | Current buffer file only (`%` resolved to absolute path) |
| `<leader>gm` | Normal | Floating Review | Branch review vs primary branch (`main...HEAD` / `master...HEAD`) |
| `q` / `<Esc>` | Terminal/Normal | Close Float | Closes floating review window and wipes buffer |
| `<leader>gvu` | Normal | Side-by-Side Split | Unstaged changes in native editor buffers (`:Difft`) |
| `<leader>gvs` | Normal | Side-by-Side Split | Staged changes in native editor buffers (`:Difft --staged`) |
| `<leader>gvm` | Normal | Side-by-Side Split | Branch vs primary branch in native editor buffers |
| `<leader>gvc` | Normal | Close Splits | Closes active Difftastic editor splits (`:DifftClose`) |
| `<leader>gvp` | Normal | Revision Picker | Opens revision picker modal (`:DifftPick`) |

#### Custom User Command
* `:DifftFloat [args]` — Opens the floating terminal with custom arguments (e.g., `:DifftFloat HEAD~2`, `:DifftFloat %`, `:DifftFloat v1.0.0...v2.0.0`).

### Architecture & Execution Flow
1. **Repository Root Detection**: Resolves root path via `git rev-parse --show-toplevel` executed with `vim.fn.systemlist`. If the command fails, it notifies the user and aborts safely.
2. **Primary Branch Resolution**: Checks for `main` via `git rev-parse --verify main`, falling back to `master`, or defaulting to `main`.
3. **Shell-Safe Execution**: Arguments are parsed into token arrays where `%` expands to the absolute file path (`vim.fn.expand("%:p")`). `vim.fn.termopen` executes Git using the list form (`{"git", "diff", ...}`) to bypass shell interpolation.
4. **ANSI Color Rendering**: Sets `GIT_EXTERNAL_DIFF="difft --color=always"` inside `termopen`'s process environment to retain full 24-bit syntax highlighting.
5. **Window Lifecycle**: Centers a rounded floating terminal window (92% width, 88% height), sets `bufhidden = "wipe"`, and cleans up windows safely upon process termination or `q` keypress.
*Assumptions: Primary branch is `main` or `master`. Git worktrees are not specially handled.*

### Troubleshooting
* **`difftastic executable ('difft') not found`**: Ensure `difft` is installed and accessible in `$PATH`. Verify with `!which difft` inside Neovim.
* **`Not inside a Git repository (git rev-parse failed)`**: Ensure the current active buffer belongs to an initialized Git repository.
* **Large Repositories / High-Volume Diffs**: For large multi-file diffs, use `<leader>gf` to inspect the current file individually, or use `:DifftFloat -- path/to/dir` to scope the diff path.

## ⚖️ Licensing

The materials in this repository are subject to two different licenses. Please read the terms carefully.

### 1. Source Code
All source code (e.g., `.py`, `.js`, `.css`, `.java` files) is licensed under the **MIT License**.

* **What this means:** You are free to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the code, including for commercial purposes, as long as you include the original copyright and license notice.
* **Full Text:** See the `LICENSE` file for details.

### 2. Content & Documentation
All other materials, including text, translations, descriptions, and documentation (e.g., `.md`, `.txt` files), are licensed under the **Creative Commons Attribution-NonCommercial 4.0 (CC BY-NC 4.0)**.

* **What this means:** You are free to share and adapt this content as long as you give appropriate credit and **do not use it for commercial purposes**.
* **Full Text:** See the `LICENSE-CONTENT.md` file for details.
