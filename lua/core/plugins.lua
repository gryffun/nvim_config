-- core/plugin.lua

vim.opt.rtp:prepend("~/.local/share/nvim/lazy/lazy.nvim")

require("lazy").setup({
    { "tpope/vim-fugitive" },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
        require("nvim-treesitter.configs").setup({
            highlight = { enable = true },
            indent = { enable = true },
        })
        end,
    },

    -- Telescope (fuzzy finder)
    {
        "nvim-telescope/telescope.nvim", tag='0.1.8',
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
        keys =
        {
            { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "Live Grep" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>",    desc = "Buffers" },
            { "<leader>fh", "<cmd>Telescope help_tags<cr>",  desc = "Help Tags" },
        },
    },

    {
        "nvim-lualine/lualine.nvim",
        config = function()
        require("lualine").setup()
        end,
    },

    {
        "neovim/nvim-lspconfig",
        config = function()
        require("lspconfig")
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
            ensure_installed = { "lua_ls", "pyright", "omnisharp", "html", "cssls" }, -- Add any LSP you want here
            automatic_installation = true,
            })
        end,
    },


})
