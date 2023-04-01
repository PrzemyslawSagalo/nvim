# nvim config 
## LSP
```lua
-- Learn the keybindings, see :help lsp-zero-keybindings
-- Learn to configure LSP servers, see :help lsp-zero-api-showcase
```

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

## Tabs and Buffers

| Key       | Action            | Description                                                       |
|-----------|-------------------|-------------------------------------------------------------------|
| `gt`      | next tab          | go to the next tab                                                |
| `gT`      | previous tab      | go to the previous tab                                            |


## Telescope
`:Telescope keymaps`

## Substitution
```
:[range]s/search/replace/[flags]
```

- `range`: (optional) a range of lines to apply the substitution, e.g., `1,5` for lines 1 to 5 or `%` for the entire file.
- `search`: the string or pattern you want to search for.
- `replace`: the string you want to replace the search string with.
- `flags`: (optional) one or more flags to modify the behavior of the substitution, e.g., `g` for global (replace all occurrences in the specified range), `i` for case-insensitive search, `c` for confirm each substitution.

## Copying
| Key       | Action              | Description                                                       |
|-----------|---------------------|-------------------------------------------------------------------|
| `"+y`     | copy to OS clipboard|                                                                   |
