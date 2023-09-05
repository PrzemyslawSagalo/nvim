local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    {"folke/tokyonight.nvim"},
    {
     "nvim-tree/nvim-tree.lua",
     version = "*",
     lazy = false,
     dependencies = {
       "nvim-tree/nvim-web-devicons"
     },
     config = function()
       require("nvim-tree").setup()
     end,
    },
    {"williamboman/mason.nvim"},
    {"nvim-lua/popup.nvim"},
    {"nvim-lua/plenary.nvim"},
    {"windwp/nvim-autopairs"},
    {"preservim/tagbar"},
    {"VonHeikemen/lsp-zero.nvim",
     dependencies = {
         {'neovim/nvim-lspconfig'},
         {'williamboman/mason.nvim'},
         {'williamboman/mason-lspconfig.nvim'},
         {'hrsh7th/nvim-cmp'},
         {'hrsh7th/cmp-buffer'},
         {'hrsh7th/cmp-path'},
         {'saadparwaiz1/cmp_luasnip'},
         {'hrsh7th/cmp-nvim-lsp'},
         {'hrsh7th/cmp-nvim-lua'},
         {'L3MON4D3/LuaSnip'},
         {'rafamadriz/friendly-snippets'}
     },
    },
    {"hrsh7th/nvim-cmp"},
    {"hrsh7th/cmp-buffer"},
    {"hrsh7th/cmp-path"},
    {"hrsh7th/cmp-cmdline"},
    {"saadparwaiz1/cmp_luasnip"},
    {"hrsh7th/cmp-nvim-lsp"},
    {"mfussenegger/nvim-dap"},
    {"mfussenegger/nvim-dap-python"},
    {"rcarriga/nvim-dap-ui"},
    {"theHamsta/nvim-dap-virtual-text"},
    {"nvim-telescope/telescope.nvim",
     dependencies = {
         {"nvim-lua/plenary.nvim"},
         {"nvim-telescope/telescope-live-grep-args.nvim"}
     },
     config = function()
         require("telescope").load_extension("live_grep_args")
     end
    },
    {"nvim-treesitter/nvim-treesitter",
     cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
     build = ":TSUpdate"
    },
    {"Pocco81/auto-save.nvim"},
    {"akinsho/bufferline.nvim",
     version = "*",
     dependencies = 'nvim-tree/nvim-web-devicons'
    },
    {"moll/vim-bbye"},
    {"Civitasv/cmake-tools.nvim"},
    {"nvim-neotest/neotest",
     dependencies = {
         "nvim-neotest/neotest-python",
         "nvim-neotest/neotest-plenary",
         "nvim-neotest/neotest-vim-test",
         "nvim-lua/plenary.nvim",
         "nvim-treesitter/nvim-treesitter",
         "antoinemadec/FixCursorHold.nvim"
     }
    }
}

require("lazy").setup(plugins)

