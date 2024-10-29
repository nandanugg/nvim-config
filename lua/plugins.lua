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
	{ "mbbill/undotree" }, -- show the undo history of a file
	{
		"chentoast/marks.nvim",
		event = "VeryLazy",
		opts = {},
	},
	{ "famiu/bufdelete.nvim" }, -- safely remove buffer without messing the layout
	{ "gbprod/substitute.nvim" }, -- replace texts
	-- { "editorconfig/editorconfig-vim" },
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
		"NeogitOrg/neogit", -- git UI
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration

			-- Only one of these is needed.
			"nvim-telescope/telescope.nvim", -- optional
			"echasnovski/mini.pick", -- optional
		},
		config = true,
	},
	{
		"f-person/git-blame.nvim", -- git blame
		event = "VeryLazy",
	},
	{
		"lewis6991/gitsigns.nvim", -- git line changes
		config = function()
			require("gitsigns").setup()
		end,
	},
	-- < git
	-- > session
	{
		"rmagatti/auto-session", -- save and restore session in open and close
		lazy = false,
	},
	-- < session
	-- > editor
	{
		"nvim-neo-tree/neo-tree.nvim", -- file explorer
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			"3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
			{
				"s1n7ax/nvim-window-picker",
				version = "2.*",
				config = function()
					require("window-picker").setup({
						filter_rules = {
							include_current_win = false,
							autoselect_one = true,
							-- filter using buffer options
							bo = {
								-- if the file type is one of following, the window will be ignored
								filetype = { "neo-tree", "neo-tree-popup", "notify" },
								-- if the buffer type is one of following, the window will be ignored
								buftype = { "terminal", "quickfix" },
							},
						},
					})
				end,
			},
		},
	},
	{ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }, -- language parser
	{
		"folke/noice.nvim", --- ui enhancement
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
	},
	{
		"roobert/tailwindcss-colorizer-cmp.nvim", -- colors on tailwind classes
		dependencies = {
			"NvChad/nvim-colorizer.lua",
		},
	},
	{
		"ray-x/lsp_signature.nvim", -- Show function signature when you type
		event = "VeryLazy",
	},
	{ "nvim-lualine/lualine.nvim" }, -- Decorate winbar & statusbar
	{
		"stevearc/aerial.nvim", -- symbol search
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
	-- < editor
	-- > lsp
	{ "williamboman/mason.nvim" }, -- programming language plugin manager
	{ "williamboman/mason-lspconfig.nvim" }, -- lsp intergration with plugin manager
	{
		"jay-babu/mason-null-ls.nvim", -- formatter intergration with plugin manager
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"nvimtools/none-ls.nvim",
		},
	},
	{ "neovim/nvim-lspconfig" }, -- lsp intergration to nvim
	-- < lsp
	-- > debugger
	{ "mfussenegger/nvim-dap" }, -- debugging
	{
		"rcarriga/nvim-dap-ui", -- debugging ui
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
	},
	{
		"theHamsta/nvim-dap-virtual-text", -- show the variable value when debugging
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"mfussenegger/nvim-dap",
		},
	},
	{ "nvim-telescope/telescope-dap.nvim" }, -- debug integration with search
	-- < debugger
	-- > autocomplete
	{
		"hrsh7th/nvim-cmp", -- autocomplete
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"saadparwaiz1/cmp_luasnip",
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
		},
	},
	-- < autocomplete
	-- > search
	{
		"junegunn/fzf", -- search by fzf
		build = 'sh -c "cd ~/.local/share/nvim/lazy/fzf && ./install --all"',
	},
	{
		"nvim-telescope/telescope.nvim", -- search
		tag = "0.1.4",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-live-grep-args.nvim" },
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim", -- search backend
		build = "make",
	},
	{ "nvim-telescope/telescope-frecency.nvim", dependencies = { "tami5/sqlite.lua" } }, -- search recent opened files
	{
		"AckslD/nvim-neoclip.lua", -- search clipboard
		dependencies = {
			{ "kkharji/sqlite.lua", module = "sqlite" },
			{ "nvim-telescope/telescope.nvim" },
		},
		config = function()
			require("neoclip").setup()
		end,
	},

	{
		"jvgrootveld/telescope-zoxide", -- search opened folders
		dependencies = {
			"nvim-lua/popup.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},
	-- < search

	-- theme
	{ "tomasiser/vim-code-dark" }, -- theme
	{
		"rebelot/kanagawa.nvim",
		lazy = false, -- Loads this plugin during startup
		priority = 1000, -- Load before other plugins to ensure colors are set early
	},

	-- Automatically check for plugin updates
	checker = { enabled = true },
})