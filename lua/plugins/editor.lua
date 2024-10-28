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
		mappings = {
			["<C-y>"] = function(state)
				local node = state.tree:get_node()
				if node then
					local full_path = node:get_id()
					local cwd = vim.fn.getcwd()
					local relative_path = vim.fn.fnamemodify(full_path, ":." .. cwd)

					vim.fn.setreg("+", relative_path) -- Yank to the system clipboard
					vim.notify("Yanked: " .. relative_path, vim.log.levels.INFO)
				else
					vim.notify("No file selected to yank", vim.log.levels.WARN)
				end
			end,
		},
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
		-- separator_style = { "", "" },
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
		keymaps = {
			init_selection = "gnn", -- Start selection with "gnn"
			node_incremental = "grn", -- Increment to the next node with "grn"
			scope_incremental = "grc", -- Increment to the next scope with "grc"
			node_decremental = "grm", -- Decrement the selection with "grm"
		},
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["at"] = "@tag.outer",
				["it"] = "@tag.inner",
			},
		},
	},
})
-- < LANGUAGE PARSER

-- > SEARCH
local actions = require("telescope.actions")
local lga_actions = require("telescope-live-grep-args.actions")
require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["<C-t>"] = actions.select_tab, -- Remove or remap if you don't want new tabs
				["<CR>"] = actions.select_default, -- Ensure default selection opens in buffer
			},
			n = {
				["<C-t>"] = actions.select_tab,
			},
		},
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
				i = {
					["<C-k>"] = lga_actions.quote_prompt(),
					["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
					-- freeze the current list and start a fuzzy search in the frozen list
					["<C-space>"] = actions.to_fuzzy_refine,
				},
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
	override = {},
	lsp = {
		signature = {
			enabled = false,
		},
	},
	routes = {},
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
-- Optional: Set for specific file types
-- vim.cmd [[
--   autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab
--   autocmd FileType lua setlocal tabstop=2 shiftwidth=2 expandtab
-- ]]
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes" -- for not interfering with gitsigns
vim.o.autoread = true
-- vim.cmd([[colorscheme nordic]])
vim.cmd([[
  autocmd FocusGained,BufEnter * checktime
]])
