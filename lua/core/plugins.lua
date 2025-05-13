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
                sync_install=true,
                auto_install=true,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },
    
    --Lua language addons
  
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
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

    -- Autocomplete with function information
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                window = {
                    completion = {
                        border = "", -- pretty border
                        max_width = 80,
                        max_height = 8,
                        scrollbar = false,
                    },
                    documentation = {
                        border = "", -- pretty border
                        max_width = 80,
                        max_height = 15,
                    },
                },

                performance = {
                    debounce = 0,    -- milliseconds of typing before it refreshes: default 0
                    throttle = 0,    -- minimum ms between two refreshes: default 0
                    fetching_timeout = 100,
                    max_view_entries = 15,
                },

                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },

                mapping = cmp.mapping.preset.insert({
                    ["<Up>"] = cmp.mapping(function(fallback) -- delete to allow up key to work in menu
                        cmp.close()
                        vim.schedule(function()
                        local key = vim.api.nvim_replace_termcodes("<C-o>k", true, false, true)
                        vim.api.nvim_feedkeys(key, "n", false)
                        end)
                    end, { "i" }),

                    ["<Down>"] = cmp.mapping(function(fallback) -- delete to allow down key to work in menu
                        cmp.close()
                        vim.schedule(function()
                        local key = vim.api.nvim_replace_termcodes("<C-o>j", true, false, true)
                        vim.api.nvim_feedkeys(key, "n", false)
                        end)
                    end, { "i" }),
                    ["<C-Space>"] = cmp.mapping.complete(),                -- trigger completion
                    ["<CR>"]      = cmp.mapping.confirm({ select = true }),-- confirm selection
                    ["<Tab>"]     = cmp.mapping.select_next_item(),        -- next entry
                    ["<S-Tab>"]   = cmp.mapping.select_prev_item(),        -- prev entry
                }),

                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip"  },
                    { name = "buffer"   },
                    { name = "path"     },
                }),
                experimental = { ghost_text = {hl_group = "Comment", } },
            })

        -- Allow cmp in cmdline
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "cmdline" },
            },
        })
        end,
    },

    -- Debug Info
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        event = "VeryLazy",
        config = function()
            require("lsp_lines").setup()
            vim.diagnostic.config({
            virtual_text = false,
            virtual_lines = { only_current_line = true },
            })
        end,
    },

    -- Display current function information under cursor
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {
            bind = true,
            handler_opts = { border = "rounded" },
            floating_window = true,
            floating_window_off_y = -2,
            max_height = 6,
            hint_enable = true,
            hint_prefix = "",
            floating_window_above_cur_line = true,  -- whether to always show above
        }
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
