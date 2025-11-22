local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'It searches for files in the current working directory' })

vim.keymap.set('n', '<leader>fa', function()
    builtin.find_files({
        no_ignore = true, -- Don't respect .gitignore
        hidden = true,    -- Show hidden files (dotfiles)
    })
end, { desc = 'iAs same as ff but search also in .* files' })

vim.keymap.set('n', '<leader>fg', builtin.git_files, { desc = 'This limits the search strictly to files currently tracked by the git index.' })

vim.keymap.set('n', '<leader>ps', function()
    require('telescope').extensions.live_grep_args.live_grep_args()
end, { desc = 'Project Search (Grep)' })
