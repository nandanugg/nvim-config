-- plugins.lua contain configurations for installed plugins
require("lazy").setup({
    -- > editing
    {
        "kylechui/nvim-surround", -- surround text
        version = "*",
        event = "VeryLazy",
    },
    { "mbbill/undotree" },                                    -- show the undo history of a file
    { "famiu/bufdelete.nvim" },                               -- safely remove buffer without messing the layout
    {
        'Wansmer/treesj',                                     -- collapse or make one liner of a arguments or objects
        dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
    },
    -- < editing
    -- > terminal
    { "akinsho/toggleterm.nvim",    version = "*", config = true }, -- terminal
    {
        "akinsho/bufferline.nvim",                                  -- tabs
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
    { "kshenoy/vim-signature" }, -- makrs manager
    -- < marks
    -- > mapping
    { "meznaric/key-analyzer.nvim", opts = {} }, -- key analyzer (find available keys)
    -- < mapping
    -- > editor
    { "karb94/neoscroll.nvim" }, -- smooth scroll
    { "szw/vim-maximizer" },     -- window maximizer
    { "ggandor/leap.nvim" },     -- jump
    {
        'echasnovski/mini.nvim',
        version = '*',
        dependencies = {
            { 'echasnovski/mini.icons',     version = '*' },
            { 'echasnovski/mini.splitjoin', version = '*' },
            { 'echasnovski/mini.files',     version = '*' },
        }
    },
    { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }, -- language parser
    {
        "roobert/tailwindcss-colorizer-cmp.nvim",             -- colors on tailwind classes
        dependencies = {
            "NvChad/nvim-colorizer.lua",
        },
    },
    { "nvim-lualine/lualine.nvim" },           -- Decorate winbar & statusbar
    {
        "lukas-reineke/indent-blankline.nvim", -- indent guides
        main = "ibl",
    },
    {
        "editorconfig/editorconfig-vim" -- apply .editorconfig
    },
    -- < editor
    -- > AI
    -- { "github/copilot.vim" },
    -- < AI
    -- > formatter
    { 'stevearc/conform.nvim' }, -- formatter
    -- < formatter
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
            { "fredrikaverpil/neotest-golang", version = "*" }, -- debug go tests
            "andythigpen/nvim-coverage",
        },
    },
    { "leoluz/nvim-dap-go" }, -- attach go debugger
    -- < debugger
    -- > autocomplete
    {
        "saghen/blink.cmp", -- autocomplete
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
        "nvim-telescope/telescope.nvim", -- secondary search
        tag = "0.1.4",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "ibhagwan/fzf-lua", -- main search plugin
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
    {
        "mistricky/codesnap.nvim", -- screenshoot code
        build = "make"
    },
    { "tomasiser/vim-code-dark" }, -- theme
    {
        "rebelot/kanagawa.nvim",   -- theme
        lazy = false,
        priority = 1000,           -- Load before other plugins to ensure colors are set early
    },

    -- Automatically check for plugin updates
    checker = { enabled = true },
}, { rocks = { enabled = false } })
