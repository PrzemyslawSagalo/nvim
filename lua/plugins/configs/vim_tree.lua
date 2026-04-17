local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then return end

local function on_attach(bufnr)
    local api = require('nvim-tree.api')

    local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- Default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- HELP: If you are seeing errors here, it's likely because the API has changed.
    -- We use pcall to safely set mappings.
    local function safe_set(mode, lhs, rhs, opt)
        if rhs then
            vim.keymap.set(mode, lhs, rhs, opt)
        end
    end

    safe_set('n', 'l',     api.node.open.edit,           opts('Open'))
    safe_set('n', '<CR>',  api.node.open.edit,           opts('Open'))
    safe_set('n', 'o',     api.node.open.edit,           opts('Open'))
    safe_set('n', 'h',     api.node.close_node,          opts('Close Node'))
    safe_set('n', 'v',     api.node.open.vertical,       opts('Open: Vertical Split'))
end

nvim_tree.setup({
    on_attach = on_attach,
    disable_netrw = true,
    hijack_netrw = true,
    hijack_cursor = false,
    diagnostics = {
        enable = true,
        icons = {hint = "", info = "", warning = "", error = ""}
    },
    update_focused_file = {enable = true, ignore_list = {}},
    git = {enable = true, ignore = true, timeout = 500},
    filters = {
        git_ignored = false,
        dotfiles = false,
    },
    view = {
        width = 30,
        side = "left",
        number = false,
        relativenumber = false
    },
    actions = {
        open_file = {
            quit_on_open = true,
            window_picker = {enable = true},
            resize_window = true
        }
    },
    renderer = {
        highlight_git = true,
        root_folder_label = ":t",
        icons = {
            show = {file = true, folder = true, folder_arrow = true, git = true},
            glyphs = {
                default = "",
                symlink = "",
                git = {
                    unstaged = "",
                    staged = "S",
                    unmerged = "",
                    renamed = "➜",
                    deleted = "",
                    untracked = "U",
                    ignored = "◌"
                },
                folder = {
                    default = "",
                    open = "",
                    empty = "",
                    empty_open = "",
                    symlink = ""
                }
            }
        }
    }
})
