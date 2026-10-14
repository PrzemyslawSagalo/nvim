return {
    "clabby/difftastic.nvim",
    main = "difftastic-nvim",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "folke/snacks.nvim",
    },
    cmd = {
        "Difft",
        "DifftClose",
        "DifftPick",
        "DifftPickRange",
        "DifftUpdate",
    },
    keys = {
        { "<leader>gd", ":Difft<CR>", desc = "Diff unstaged changes" },
        { "<leader>gs", ":Difft --staged<CR>", desc = "Diff staged changes" },
        { "<leader>gp", ":DifftPick<CR>", desc = "Pick commit or revision to diff" },
        { "<leader>gb", ":<C-u>Difft ", silent = false, desc = "Diff branch or commit" },
        { "<leader>gq", ":DifftClose<CR>", desc = "Close diff view" },
    },
    opts = {
        download = true,
        vcs = "git",
        snacks_picker = {
            enabled = true,
        },
    },
}
