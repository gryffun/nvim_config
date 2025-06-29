-- core/plugin.lua
local parser_path = vim.fn.stdpath("data") ..
    "/site/parser"                                               --.dlls need installed separatedly it pouints to site/parser but they point to programs/neovim/lib
vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/lazy.nvim") -- Fixed path resolution

local colour_theme = "tokyonight" -- change to tokyonights or whatever if u want. I like to mix it up every now n then

require("lazy").setup({
    defaults = {
        -- only load plugins when NOT in VS Code
        cond = function() return vim.fn.exists('g:vscode') == 0 end,
    },

    -- git plugin for vim
    { "tpope/vim-fugitive" },
    -- adds icons and fonts
    { "nvim-tree/nvim-web-devicons",   opts = {} },
    -- view assembly Code compiled from c langs
    { 'krady21/compiler-explorer.nvim' },
    -- Display reference and definition info above funcs
    {'VidocqH/lsp-lens.nvim'},

    -- Text wrapping for signs like "" or ()
    {
        "doums/tenaille.nvim",
        config = function()
            require("tenaille").setup({
                default_mapping = false,
            })
        end
    },


    -- Clean trailing whitespace on save
    {
        "mcauley-penney/tidy.nvim",
        opts = {
            enabled_on_save = true,                   -- set to false to turn off
            filetype_exclude = { "markdown", "diff" } -- won't act on these files'
        },
    },

    -- Colour schemes
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 10,
        opts = {},
    },

    {
        "sainnhe/everforest",
        lazy = false,
        priority = 1000,
    },

    -- Indent lines and current scope highlighting
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        opts = {},
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        -- during startup, make sure Neovim can see that parser folder
        init = function()
            vim.opt.runtimepath:append(parser_path)
        end,
        -- these opts get passed into nvim-treesitter.configs.setup()
        opts = {
            parser_install_dir = parser_path,
            ensure_installed   = {
                "c", "c_sharp", "lua", "markdown",
                "css", "html", "javascript", "python"
            },
            sync_install       = true,
            auto_install       = true,
            highlight          = { enable = true },
            indent             = { enable = true },
        },
        -- standard Lazy.nvim pattern to call setup(opts)
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },

    -- Fuzzy Finder
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        lazy = false,
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({
                defaults = {
                    layout_config = { prompt_position = "top" },
                    sorting_strategy = "ascending",
                    winblend = 10,
                    file_ignore_patterns = {
                        "%.meta$",
                        "%.sample$",
                        ".git/*"
                    },
                    respect_gitignore = true,
                }
            })
        end,
    },
    { 'junegunn/fzf' }, -- fzf syntax

    -- Telescope add on for better grep (faster and with support for fzf syntax)
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release'
    },


    -- Current Line Highlighting
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("lualine").setup({
                options = { theme = colour_theme } 
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


    -- CMP for autocomplete + sources + LuaSnip integration
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",     -- include snippets
            "rafamadriz/friendly-snippets", -- include vscode snippets
        },
        config = function()
            local cmp = require("cmp")
            local ls = require("luasnip")

            -- Load VSCode snippets from friendly-snippets
            -- Can improve this to be language agnostic and load tables for current lang maybe
            require("luasnip.loaders.from_vscode").lazy_load()

            -- Load your own Lua snippets directory (adjust this path)
            local snippet_dir = vim.fn.stdpath("config") ..
                "/lua/core/snippets" -- If on windows maybe change the / to \\
            require("luasnip.loaders.from_lua").lazy_load({ paths = { snippet_dir } })

            -- CMP setup
            cmp.setup({
                snippet = {
                    expand = function(args)
                        ls.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<Up>"]      = cmp.mapping(function(fallback) -- delete to allow up key to work in menu
                        cmp.close()
                        vim.schedule(function()
                            local key = vim.api.nvim_replace_termcodes("<C-o>k", true, false, true)
                            vim.api.nvim_feedkeys(key, "n", false)
                        end)
                    end, { "i" }),

                    ["<Down>"]    = cmp.mapping(function(fallback) -- delete to allow down key to work in menu
                        cmp.close()
                        vim.schedule(function()
                            local key = vim.api.nvim_replace_termcodes("<C-o>j", true, false, true)
                            vim.api.nvim_feedkeys(key, "n", false)
                        end)
                    end, { "i" }),

                    ["<C-Space>"] = cmp.mapping.complete(),                 -- trigger completion
                    ["<CR>"]      = cmp.mapping.confirm({ select = false }), -- confirm selection
                    ["<Tab>"]     = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"]   = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp", priority = 750 },
                    { name = "luasnip",  priority = 1000 },
                    { name = "buffer",   priority = 500 },
                    { name = "path",     priority = 250 },
                }),
                window = {
                    completion = {
                        border = "", max_width = 80, max_height = 8, scrollbar = false,
                    },
                    documentation = {
                        border = "", max_width = 80, max_height = 15,
                    },
                },
                performance = {
                    debounce = 0,
                    throttle = 0,
                    fetching_timeout = 500,
                    max_view_entries = 15,
                },
                experimental = {
                    ghost_text = { hl_group = "Conceal" },
                },
            })

            -- Allow cmp in cmdline
            cmp.setup.cmdline({ '/', '?' }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' }
                }
            })
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path', option = { trailing_slash = true }, }
                }, {
                    { name = 'cmdline', option = { treat_trailing_slash = false } }
                }),
                matching = { disallow_symbol_nonprefix_matching = false }
            })
            cmp.setup.filetype("tex", {
                sources = {
                    { name = 'vimtex' },
                    { name = 'luasnip' },
                    { name = 'buffer' },
                },
            })
        end,
    },





    {
        "piersolenski/wtf.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        opts = {},
        keys = {
            {
                "<leader>wa",
                mode = { "n", "x" },
                function()
                    require("wtf").ai()
                end,
                desc = "Debug diagnostic with AI",
            },
            {
                mode = { "n" },
                "<leader>ws",
                function()
                    require("wtf").search()
                end,
                desc = "Search diagnostic with Google",
            },
            {
                mode = { "n" },
                "<leader>wh",
                function()
                    require("wtf").history()
                end,
                desc = "Populate the quickfix list with previous chat history",
            },
            {
                mode = { "n" },
                "<leader>wg",
                function()
                    require("wtf").grep_history()
                end,
                desc = "Grep previous chat history with Telescope",
            },
        },
    },

    -- Display current function information under cursor
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {
            bind = true,
            handler_opts = { border = "rounded" },
            floating_window = false,
            floating_window_off_y = -2,
            floating_window_above_cur_line = true, -- whether to always show above
            transparancy = 50,
            max_height = 6,

            hint_enable = true,
            hint_prefix = {
                above = "↙ ", -- when the hint is on the line above the current line
                current = "← ", -- when the hint is on the same line
                below = "↖ " -- when the hint is on the line below the current line
            },
            hint_inline = function() return false end,
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
    },

    -- Side on file list
    {
        "nvim-tree/nvim-tree.lua",
        config = function()
            require("nvim-tree").setup()
        end
    },

    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },


    -- Better formatting for different languages
    -- Use the vim cmd ":Mason" and press 5 in its menu and download these formatters if you want to use them
    {
        "stevearc/conform.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local conform = require("conform")
            conform.setup({
                formatters = {
                    ["clang-format"] = {
                        prepend_args = {
                            "-style={ BasedOnStyle: LLVM, IndentWidth: 4, TabWidth: 4, BreakBeforeBraces: Allman }",
                        },
                    },
                },
                formatters_by_ft = {
                    c = { "clang-format" },
                    cpp = { "clang-format" },
                    javascript = { "prettier" },
                    typescript = { "prettier" },
                    javascriptreact = { "prettier" },
                    typescriptreact = { "prettier" },
                    svelte = { "prettier" },
                    css = { "prettier" },
                    html = { "prettier" },
                    json = { "prettier" },
                    yaml = { "prettier" },
                    markdown = { "prettier" },
                    graphql = { "prettier" },
                    lua = { "stylua" },
                    python = { "isort", "black" },
                },
                format_on_save = {
                    lsp_fallback = true,
                    async = false,
                    timeout_ms = 500,
                },
            })

            vim.keymap.set({ "n", "v" }, "<leader>mp", function()
                conform.format({
                    lsp_fallback = true,
                    async = false,
                    timeout_ms = 500,
                })
            end, { desc = "Format file or range (in visual mode)" })
        end,
    },

    -- Nicer Nvim tabs
    {
        'romgrk/barbar.nvim',
        dependencies = {
            'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
        },
        init = function() vim.g.barbar_auto_setup = false end,
        opts = {
            -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
            -- animation = true,
            -- insert_at_start = true,
            -- …etc.
        },

    }
})


-- non-lsp plugin additional set up

vim.cmd("colorscheme " .. colour_theme)
require("ibl").setup()

vim.diagnostic.config({
  -- show virtual text (inline) for errors and warnings
  virtual_text = {
    spacing = 4,           -- how many spaces to leave between code and text
    prefix = "●",          -- symbol to use before the message
    source = "if_many",
    severity = { min = vim.diagnostic.severity.WARN },
    -- you can lower min to INFO/DEBUG if you want more messages
  },
  signs = true,
  underline = true,
})

