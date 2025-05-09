-- core/plugin.lua

vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/lazy.nvim")  -- Fixed path resolution

require("lazy").setup({
    { "tpope/vim-fugitive" },

    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        opts = {},
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "c", "c_sharp", "gdscript", "lua", "markdown",
                    "css", "html", "javascript", "python"
                },
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },

    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({
                defaults = {
                    layout_config = { prompt_position = "top" },
                    sorting_strategy = "ascending",
                    winblend = 10,
                }
            })
        end,
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "Live Grep" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>",    desc = "Buffers" },
            { "<leader>fh", "<cmd>Telescope help_tags<cr>",  desc = "Help Tags" },
        },
    },

    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("lualine").setup({
            options={ theme = "tokyonight"}
            })
        end,
    },

    {
        "neovim/nvim-lspconfig",
        lazy = false,
        dependencies = {
            { "ms-jpq/coq.nvim", branch = "coq" },
            { "ms-jpq/coq.artifacts", branch = "artifacts" },
            { "ms-jpq/coq.thirdparty", branch = "3p" },
        },
        init = function()
            vim.g.coq_settings = { auto_start = true, }
        end,
    },

    {
        "williamboman/mason.nvim",
        config = true,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls", "pyright", "omnisharp", "html", "cssls"
                },
                automatic_installation = true,
            })
        end,
    },
})


-- non-lsp plugin set up

vim.cmd[[colorscheme tokyonight]]
require("ibl").setup()


