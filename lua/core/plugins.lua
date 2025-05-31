
-- core/plugin.lua
local parser_path = vim.fn.stdpath("data") ..
    "/site/parser"                                               --.dlls need installed separatedly it pouints to site/parser but they point to programs/neovim/lib
vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/lazy.nvim") -- Fixed path resolution

require("lazy").setup({
    defaults = {
        -- only load plugins when NOT in VS Code
        cond = function() return vim.fn.exists('g:vscode') == 0 end,
    },

    -- git plugin for vim
    { "tpope/vim-fugitive" },
    -- adds icons and fonts
    { "nvim-tree/nvim-web-devicons", opts = {} },
    -- multi line typing
    { "mg979/vim-visual-multi" }, -- needs some rebinds i think
    -- view assembly Code compiled from c langs
    {'krady21/compiler-explorer.nvim'},


    -- Text wrapping for signs like "" or ()
    {
        "doums/tenaille.nvim",
        config=function()
            require("tenaille").setup({
                default_mapping=false,
            })
        end
    },


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
        lazy=false,
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
    {'junegunn/fzf'}, -- fzf syntax

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
            floating_window = false,
            floating_window_off_y = -2,
            floating_window_above_cur_line = true,  -- whether to always show above
            transparancy=50,
            max_height = 6,

            hint_enable = true,
            hint_prefix = {
            above = "↙ ",  -- when the hint is on the line above the current line
            current = "← ",  -- when the hint is on the same line
            below = "↖ "  -- when the hint is on the line below the current line
            },
            hint_inline=function() return false end,
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

    -- Snippet engine
    {
      "L3MON4D3/LuaSnip",
      dependencies = { "rafamadriz/friendly-snippets" },
      config = function()
        local ls = require("luasnip")
        require("luasnip.loaders.from_vscode").lazy_load()
        vim.keymap.set({ "i", "s" }, "<C-Tab>", function()
          if ls.expand_or_jumpable() then ls.expand_or_jump() end
        end, { silent = true })
        vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
          if ls.jumpable(-1) then ls.jump(-1) end
        end, { silent = true })
      end,
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
                    prepend_args = { "-style={ BasedOnStyle: LLVM, IndentWidth: 4, TabWidth: 4, BreakBeforeBraces: Allman }",
                    },
                },
            },
            formatters_by_ft = {
                c= { "clang-format" },
                cpp= { "clang-format" },
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


})


-- non-lsp plugin additional set up

vim.cmd[[colorscheme tokyonight]]
require("ibl").setup()



