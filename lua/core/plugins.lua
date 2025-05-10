-- core/plugin.lua

vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/lazy.nvim")  -- Fixed path resolution

require("lazy").setup({
    -- git plugin for vim
    { "tpope/vim-fugitive" },
    -- adds icons and fonts
    { "nvim-tree/nvim-web-devicons", opts = {} },

    -- Clean trailing whitespace on save
    {
    "mcauley-penney/tidy.nvim",
    opts = {
        enabled_on_save = true, -- set to false to turn off
        filetype_exclude = { "markdown", "diff" } -- won't act on these files'
        },
    },

    -- Colour schemes
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },

    -- Indent lines and current scope highlighting
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        opts = {},
    },

    -- Treesitter is required for current nvim versions
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

    -- Fuzzy Finder
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

    -- Current Line Highlighting
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("lualine").setup({
            options={ theme = "tokyonight"}
            })
        end,
    },

    -- LSP stuff
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        dependencies = {
            { "ms-jpq/coq.nvim", branch = "coq" },
            { "ms-jpq/coq.artifacts", branch = "artifacts" },
            { "ms-jpq/coq.thirdparty", branch = "3p" },
        },
        init = function()
            vim.g.coq_settings = {
            auto_start = true,
            display = {
                pum = { y_max_len = 6 },
                },
            }
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

    -- Scrollbar with debug colouration
    {
        "petertriho/nvim-scrollbar",
        config = function()
            local colors = require("tokyonight.colors").setup()
            require("scrollbar").setup({
                handle = {
                    color = colors.bg_highlight,
                },
                marks = {
                    Search = { color = colors.orange },
                    Error = { color = colors.error },
                    Warn = { color = colors.warning },
                    Info = { color = colors.info },
                    Hint = { color = colors.hint },
                    Misc = { color = colors.purple },
                }
            })
        end,
        -- dependencies = { "folke/tokyonight.nvim" }  -- not necessarily needed if not using colors from tokyonight or have it set up elsewhere
    }

})


-- non-lsp plugin additional set up

vim.cmd[[colorscheme tokyonight]]
require("ibl").setup()


