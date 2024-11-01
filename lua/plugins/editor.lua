local keymaps = require("keymaps")

-- theme
require("kanagawa").setup({
	compile = true, -- enable compiling the colorscheme
	undercurl = true, -- enable undercurls
	commentStyle = { italic = true },
	functionStyle = {},
	keywordStyle = { italic = true },
	statementStyle = { bold = true },
	typeStyle = {},
	transparent = false, -- do not set background color
	dimInactive = false, -- dim inactive window `:h hl-NormalNC`
	terminalColors = true, -- define vim.g.terminal_color_{0,17}
	colors = { -- add/modify theme and palette colors
		palette = {},
		theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
	},
	overrides = function(colors) -- add/modify highlights
		return {}
	end,
	-- theme = "", -- Load "wave" theme when 'background' option is not set
	background = { -- map the value of 'background' option to a theme
		dark = "wave", -- try "dragon" !
		light = "dragon",
	},
})
-- setup must be called before loading
vim.cmd("colorscheme kanagawa")

-- > FILE EXPLORER
require("neo-tree").setup({
	window = {
		position = "right",
		mappings = keymaps.mappings.neotree,
		auto_expand_width = true,
	},
	popup_border_style = "rounded",
	enable_git_status = true,
	filesystem = {
		restrict_to_cwd = true,
		filtered_items = {
			visible = true,
			hide_dotfiles = false,
			never_show = {
				".DS_Store",
				"thumbs.db",
			},
		},
		follow_current_file = {
			enabled = true,
			leave_dirs_open = false,
		},
		hijack_netrw_behavior = "open_current", -- Open Neo-tree on netrw calls
	},
	buffers = {
		follow_current_file = {
			enabled = true,
			leave_dirs_open = false,
		},
	},
})
-- < FILE EXPLORER
-- > BUFFER SUPPORT
require("bufferline").setup({
	options = {
		diagnostics = "nvim_lsp", -- Show LSP diagnostics in the bufferline
		themable = true,
		separator_style = "slant",
		tab_size = 13,
		show_buffer_close_icons = false,
		diagnostics_indicator = function(count, level, diagnostics_dict, context)
			local icon = level:match("error") and " " or " "
			return " " .. icon .. count
		end,
	},
	highlights = {},
})
-- > BUFFER SUPPORT
-- > MARKS
require("marks").setup({})
-- < MARKS

-- > LANGUAGE PARSER
require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true,
		ensure_installed = {
			-- web dev
			"html",
			"css",
			"javascript",
			"typescript",
			"tsx",
			"astro",
			"vue",
			"svelte",
			"graphql",
			-- backend dev
			"go",
			"gomod",
			"gosum",
			"terraform",
			"python",
			"java",
			"php",
			"phpdoc",
			"nginx",
			"nix",
			"dockerfile",
			"sql",
			"bash",
			-- config dev
			"lua",
			"json",
			"jsonc",
			"yaml",
			"csv",
			"markdown",
			"markdown_inline",
			"git_config",
			"regex",
			"ssh_config",
			"vim",
			"tmux",
			"ssh_config",
		},
		additional_vim_regex_highlighting = false,
	},
	incremental_selection = {
		enable = true,
		keymaps = keymaps.mappings.treesitter.incremental_selection_keymaps,
	},
})
-- < LANGUAGE PARSER

-- > SEARCH
local lga_actions = require("telescope-live-grep-args.actions")
require("telescope").setup({
	defaults = {
		sorting_strategy = "ascending", -- Options: "ascending" or "descending"
		layout_strategy = "vertical", -- Choose "horizontal", "vertical", "center", "flex"
		layout_config = {
			width = 0.7, -- Width as a proportion of the screen (e.g., 80% of the screen)
			height = 0.8, -- Height as a proportion of the screen
			prompt_position = "top", -- Position of the prompt; can be "top" or "bottom"

			-- horizontal = {
			-- 	preview_width = 0.5, -- Width of the preview window for horizontal layout
			-- 	mirror = false, -- Flip the results and preview positions
			-- },
			vertical = {
				preview_height = 0.5, -- Height of the preview window for vertical layout
				mirror = true,
			},
			-- center = {
			-- 	preview_cutoff = 40, -- When to switch to center layout instead of flex
			-- 	width = 0.5,
			-- 	height = 0.4,
			-- },
			-- flex = {
			-- 	flip_columns = 120, -- At this column width, Telescope will switch to vertical layout
			-- },
		},
		mappings = keymaps.mappings.telescope,
		file_ignore_patterns = {
			"node_modules",
			"%.git/",
			"vendor/",
			"dist/",
			"__pycache__/",
			"%.lock",
			"build/",
			"tmp/",
		},
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--glob",
			"!.git/*",
			"--glob",
			"!node_modules/*",
			"--glob",
			"!vendor/*",
		},
	},
	extensions = {
		aerial = {
			col1_width = 4,
			col2_width = 30,
			format_symbol = function(symbol_path, filetype)
				if filetype == "json" or filetype == "yaml" then
					return table.concat(symbol_path, ".")
				else
					return symbol_path[#symbol_path]
				end
			end,
			show_columns = "both",
		},
		zoxide = {
			prompt_title = "[ Open folder ]",
			mappings = {
				default = {
					after_action = function(selection)
						print("Update to (" .. selection.z_score .. ") " .. selection.path)
					end,
				},
			},
		},
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
		},
		live_grep_args = {
			auto_quoting = true, -- enable/disable auto-quoting
			-- define mappings, e.g.
			mappings = { -- extend mappings
				i = {},
			},
			-- ... also accepts theme settings, for example:
			-- theme = "dropdown", -- use dropdown theme
			-- theme = { }, -- use own theme spec
			-- layout_config = { mirror=true }, -- mirror preview pane
		},
	},
})
require("aerial").setup({
	backends = { "treesitter", "lsp", "markdown", "asciidoc", "man" },
})
require("telescope").load_extension("aerial")
require("telescope").load_extension("frecency") -- recent opened file
require("telescope").load_extension("neoclip") -- clipboard
require("telescope").load_extension("fzf") -- search backend
require("telescope").load_extension("live_grep_args") -- replace string
require("telescope").load_extension("ui-select") -- decorate the ui for selection
-- < SEARCH

-- > RECENT OPENED DIRECTORY
local function add_to_zoxide()
	local cwd = vim.fn.getcwd() -- Get the current working directory
	vim.fn.jobstart({ "zoxide", "add", cwd }, { detach = true }) -- Run 'zoxide add <cwd>'
end
require("telescope").load_extension("zoxide")
vim.api.nvim_create_autocmd("DirChanged", {
	pattern = "*",
	callback = function()
		add_to_zoxide()
	end,
})
-- < RECENT OPENED DIRECTORY

-- > UI EHANCEMENT
require("noice").setup({
	messages = {
		enabled = false, -- Set to false if you want to disable Noice handling of `:messages`
	},
	lsp = {
		signature = {
			enabled = false,
		},
	},
	notify = {
		enabled = true, -- Set to false if you want default `vim.notify` behavior
	},
})
require("telescope").load_extension("noice")
require("ibl").setup({
	scope = {
		enabled = true,
		show_start = true,
		show_end = false,
		injected_languages = false,
		char = "╏",
		-- highlight = { "Function", "Label" },
		priority = 500,
	},
	indent = {
		char = "╎",
	},
})
-- < UI EHANCEMENT

vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.wo.foldlevel = 99
vim.o.foldmethod = "manual"
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 4 -- Size of an indent (number of spaces)
vim.opt.tabstop = 4 -- Number of spaces that a <Tab> in the file counts for
vim.opt.softtabstop = 4 -- Number of spaces tabs count when editing
vim.opt.autoindent = true -- Copy indent from the current line when starting a new one
vim.opt.smartindent = true -- Makes indenting smart (good for programming)
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes" -- for not interfering with gitsigns
vim.o.autoread = true
vim.cmd([[
  autocmd FocusGained,BufEnter * checktime
]])
