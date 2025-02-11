-- Setup lazy.nvim
require("lazy").setup({
    -- > editing
    {
        "kylechui/nvim-surround", -- surround text
        version = "*",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end,
    },
    { "mbbill/undotree" },        -- show the undo history of a file
    { "famiu/bufdelete.nvim" },   -- safely remove buffer without messing the layout
    { "gbprod/substitute.nvim" }, -- replace texts
    -- < editing
    -- > terminal
    { "akinsho/toggleterm.nvim", version = "*", config = true }, -- terminal
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = "nvim-tree/nvim-web-devicons",
    },
    -- < terminal
    -- > git
    {
        "tpope/vim-fugitive", -- git toolkit
    },
    {
        "lewis6991/gitsigns.nvim", -- git changes
    },
    -- < git
    -- > session
    {
        "rmagatti/auto-session", -- save and restore session in open and close
        lazy = false,
    },
    -- < session
    -- > marks
    { "kshenoy/vim-signature" },
    -- < marks
    -- > editor
    { "karb94/neoscroll.nvim" },                              -- smooth scroll
    { "szw/vim-maximizer" },                                  -- window maximizer
    { "nvim-tree/nvim-tree.lua" },                            -- file explorer
    { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }, -- language parser
    {
        "roobert/tailwindcss-colorizer-cmp.nvim",             -- colors on tailwind classes
        dependencies = {
            "NvChad/nvim-colorizer.lua",
        },
    },
    { "nvim-lualine/lualine.nvim" }, -- Decorate winbar & statusbar
    {
        "stevearc/aerial.nvim",      -- symbol search
        opts = {},
        -- Optional dependencies
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
    },
    {
        "lukas-reineke/indent-blankline.nvim", -- indent guides
        main = "ibl",
    },
    {
        "editorconfig/editorconfig-vim"
    },
    -- < editor
    -- > lsp
    { "williamboman/mason.nvim" },           -- programming language plugin manager
    { "williamboman/mason-lspconfig.nvim" }, -- lsp intergration with plugin manager
    { "neovim/nvim-lspconfig" },             -- lsp intergration to nvim
    -- < lsp
    -- > debugger
    { "mfussenegger/nvim-dap" }, -- debugging
    {
        "rcarriga/nvim-dap-ui",  -- debugging ui
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
    },
    { "nvim-telescope/telescope-dap.nvim" }, -- debug integration with search
    {
        "nvim-neotest/neotest",              -- debug tests
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
    },
    {
        "olimorris/neotest-phpunit", -- debug php test
        build = function()
            os.execute(
                'if [[ "$OSTYPE" == "darwin"* ]]; then sed -i "" "/cwd = async.fn.getcwd()/d" ~/.local/share/nvim/lazy/neotest-phpunit/lua/neotest-phpunit/init.lua; else sed -i "/cwd = async.fn.getcwd()/d" ~/.local/share/nvim/lazy/neotest-phpunit/lua/neotest-phpunit/init.lua; fi'
            )
        end,
    },
    -- < debugger
    -- > autocomplete
    {
        "saghen/blink.cmp",
        -- optional: provides snippets for the snippet source
        dependencies = "rafamadriz/friendly-snippets",

        -- use a release tag to download pre-built binaries
        version = "*",
        -- build = 'cargo build --release',
        opts_extend = { "sources.default" },
    },
    -- < autocomplete
    -- > search
    {
        "nvim-telescope/telescope.nvim", -- search
        tag = "0.1.4",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    { "nvim-telescope/telescope-frecency.nvim", dependencies = { "tami5/sqlite.lua" } }, -- search recent opened files
    {
        "AckslD/nvim-neoclip.lua",                                                       -- search clipboard
        dependencies = {
            { "kkharji/sqlite.lua",           module = "sqlite" },
            { "nvim-telescope/telescope.nvim" },
        },
        config = function()
            require("neoclip").setup()
        end,
    },
    -- < search

    -- theme
    { "tomasiser/vim-code-dark" }, -- theme
    {
        "rebelot/kanagawa.nvim",
        lazy = false,    -- Loads this plugin during startup
        priority = 1000, -- Load before other plugins to ensure colors are set early
    },

    -- Automatically check for plugin updates
    checker = { enabled = true },
}, { rocks = { enabled = false } })
