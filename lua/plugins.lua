-- plugins.lua contain configurations for installed plugins

require("lazy").setup({
    -- === UI
    {
        "rebelot/kanagawa.nvim", -- theme
        lazy = false,
        priority = 1000,
    },
    {
        "akinsho/bufferline.nvim", -- tabs for buffers
        version = "*",
        dependencies = "nvim-tree/nvim-web-devicons",
    },
    { "nvim-lualine/lualine.nvim" },                                                  -- statusbar
    { "SmiteshP/nvim-navic",            dependencies = { "neovim/nvim-lspconfig" } }, -- winbar
    {
        "SmiteshP/nvim-navbuddy",                                                     -- symbol navigator
        dependencies = {
            "neovim/nvim-lspconfig",
            "SmiteshP/nvim-navic",
            "MunifTanjim/nui.nvim",
        },
    },
    {
        "lukas-reineke/indent-blankline.nvim", -- indent guides
        main = "ibl",
    },
    { "karb94/neoscroll.nvim" },     -- smooth scroll
    { "sphamba/smear-cursor.nvim" }, -- cursor animation
    { "szw/vim-maximizer" },         -- window maximizer
    { "famiu/bufdelete.nvim" },      -- safely remove buffer without messing the layout
    { "echasnovski/mini.icons",      version = "*" }, -- icons for files

    -- === TOOLS
    { "akinsho/toggleterm.nvim",    version = "*", config = true }, -- terminal
    { "meznaric/key-analyzer.nvim", opts = {} },                    -- key analyzer (find available keys)
    {
        "mistricky/codesnap.nvim", -- code screenshot
        tag = "v2.0.0",
        config = function()
            require("codesnap").setup({
                snapshot_config = {
                    window = {
                        border = { width = 0, color = "#ffffff00" },
                    },
                },
            })
        end,
    },
    { "mbbill/undotree" },                                           -- show the undo history of a file
    { "rmagatti/auto-session" },                                     -- auto session
    {
        "AckslD/nvim-neoclip.lua", -- search clipboard
        dependencies = {
            { "kkharji/sqlite.lua",           module = "sqlite" },
            { "nvim-telescope/telescope.nvim" },
        },
        config = function()
            require("neoclip").setup()
        end,
    },
    { "kshenoy/vim-signature" },                     -- marks manager
    { "editorconfig/editorconfig-vim" },             -- apply .editorconfig
    { "tpope/vim-fugitive" },                        -- git toolkit
    { "lewis6991/gitsigns.nvim" },                   -- git changes
    {
        "nvim-telescope/telescope.nvim", -- main search plugin
        tag = "0.1.4",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "ibhagwan/fzf-lua", -- fuzzy finder
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    { "nvim-telescope/telescope-frecency.nvim", dependencies = { "tami5/sqlite.lua" } }, -- search recent opened files
    { "echasnovski/mini.files",                 version = "*" },                          -- file explorer
    {
        "folke/flash.nvim", -- jump
        event = "VeryLazy",
        opts = {},
    },

    -- === EDITOR
    { "nvim-treesitter/nvim-treesitter" },           -- language parser
    { "williamboman/mason.nvim" },                   -- programming language plugin manager
    { "williamboman/mason-lspconfig.nvim" },         -- lsp integration with plugin manager
    { "zapling/mason-conform.nvim" },                -- lsp integration with formatter
    { "neovim/nvim-lspconfig" },                     -- lsp integration to nvim
    { "stevearc/conform.nvim" },                     -- formatter
    {
        "saghen/blink.cmp", -- autocomplete
        dependencies = {
            'saghen/blink.lib',
            'rafamadriz/friendly-snippets',
        },
        version = "*",
        opts_extend = { "sources.default" },
    },
    {
        "roobert/tailwindcss-colorizer-cmp.nvim", -- colors on tailwind classes
        dependencies = {
            "NvChad/nvim-colorizer.lua",
        },
    },
    {
        "kylechui/nvim-surround", -- surround text
        version = "*",
        event = "VeryLazy",
    },
    { "arthurxavierx/vim-caser" },  -- transform text case
    { "Wansmer/treesj" },           -- collapse or expand arguments or objects
    { "echasnovski/mini.splitjoin", version = "*" }, -- flatten code

    -- === DEBUGGER
    { "mfussenegger/nvim-dap" }, -- debugging
    {
        "rcarriga/nvim-dap-ui", -- debugging ui
        dependencies = {
            "mfussenegger/nvim-dap",
        },
    },
    { "nvim-telescope/telescope-dap.nvim" }, -- debug integration with search
    {
        "nvim-neotest/neotest", -- test runner
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "andythigpen/nvim-coverage",
            {
                "fredrikaverpil/neotest-golang",
                version = "*",
                -- build = function()
                --     vim.system({ "go", "install", "gotest.tools/gotestsum@latest" }):wait() -- Optional, but recommended
                -- end,
            },                        -- go test runner
            { "leoluz/nvim-dap-go" }, -- attach go debugger
        },
    },

    -- Automatically check for plugin updates
    checker = { enabled = true },
}, { rocks = { enabled = false } })
