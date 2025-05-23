# NVIM CONFIGURATION

## Architectural drivers
* This is a standalone repository as it gives the possibility to: change, test and push.

## DAP Python
```
import pandas as pd; pd.set_option("display.max_rows", 999999); pd.set_option("display.max_columns", 999999); pd.set_option("display.max_colwidth", 999999)
```

# NVIM shortcuts
## General
| Key       | Action                                  |
|-----------|-----------------------------------------|
| `"+y`     | copy to OS clipboard                    |
| `sort i`  | sort lines in a case-insensitive manner |
| `:norm A[sign to put]`| put a sign at the end of a line|

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
