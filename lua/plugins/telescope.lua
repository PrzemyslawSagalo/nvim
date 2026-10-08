return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-live-grep-args.nvim"
    },
    config = function()
local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'It searches for files in the current working directory' })

vim.keymap.set('n', '<leader>fa', function()
    builtin.find_files({
        no_ignore = true, -- Don't respect .gitignore
        hidden = true,    -- Show hidden files (dotfiles)
    })
end, { desc = 'iAs same as ff but search also in .* files' })

vim.keymap.set('n', '<leader>fg', function()
    require('telescope').extensions.live_grep_args.live_grep_args()
end, { desc = 'Project Search (Grep)' })

-- Load extensions
require("telescope").load_extension("live_grep_args")

    end
}
