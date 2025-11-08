local builtin = require('telescope.builtin')

-- Find files in your current working directory, respecting .gitignore
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })

-- Find ALL files, including dotfiles and files in .gitignore (e.g., venv)
vim.keymap.set('n', '<leader>fa', function()
    builtin.find_files({
        no_ignore = true, -- Don't respect .gitignore
        hidden = true,    -- Show hidden files (dotfiles)
    })
end, { desc = 'Find All Files' })

-- Find files tracked by git (super fast and often the most relevant)
vim.keymap.set('n', '<leader>fg', builtin.git_files, { desc = 'Find Git Files' })

-- Live Grep (search for strings in files)
vim.keymap.set('n', '<leader>ps', function() -- 'ps' for Project Search
    -- Using the live_grep_args extension to dynamically add arguments
    require('telescope').extensions.live_grep_args.live_grep_args()
end, { desc = 'Project Search (Grep)' })
