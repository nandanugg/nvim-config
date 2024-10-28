-- > MASON
require("mason").setup({
	ui = {
		border = "rounded",
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})
-- < MASON

-- TailwindCSS colorizer setup
local tailwindcss = require("tailwindcss-colorizer-cmp")
tailwindcss.setup({
	color_square_width = 2,
})

-- > CODE COMPLETIONS (CMP)
local cmp = require("cmp")
require("luasnip.loaders.from_vscode").lazy_load()

local function tab_mapping(fallback)
	if cmp.visible() then
		cmp.select_next_item()
	else
		fallback()
	end
end

local function shift_tab_mapping(fallback)
	if cmp.visible() then
		cmp.select_prev_item()
	else
		fallback()
	end
end

cmp.setup({
	formatting = {
		format = tailwindcss.formatter,
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = {
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping(tab_mapping, { "i", "s", "c" }),
		["<S-Tab>"] = cmp.mapping(shift_tab_mapping, { "i", "s", "c" }),
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	}, {
		{ name = "buffer" },
		{ name = "path" },
	}),
})

cmp.setup.cmdline("/", {
	sources = {
		{ name = "buffer" },
	},
})
cmp.setup.cmdline(":", {
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})
-- < CODE COMPLETIONS (CMP)

-- > SYMBOLS

-- Set up lualine using the same theme colors
require("lualine").setup({
	options = {
		globalstatus = true,
		component_separators = "",
		section_separators = { left = "", right = "" },
	},
	sections = {
		lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
		lualine_b = { "branch", "diff", "filename" },
		lualine_c = { "aerial" },
		lualine_x = { "encoding", "filetype" },
		lualine_y = {},
		lualine_z = { { "location", separator = { right = "" }, left_padding = 2 } },
	},
})
-- < SYMBOLS

-- > LSP SETUP
local function lsp_attach(client, bufnr)
	if client.server_capabilities.documentSymbolProvider then
		-- navic.attach(client, bufnr)
	end
	if client.server_capabilities.document_diagnostics then
		require("bufferline").setup({
			options = {
				diagnostics = "nvim_lsp",
			},
		})
	end
	require("lsp_signature").on_attach({
		bind = true,
		handler_opts = {
			border = "shadow",
		},
		max_height = 10,
		padding = "  ",
		timer_interval = 100,
	}, bufnr)
end

-- Create an LspAttach autocommand for setting up LSP-related functionalities
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local bufnr = args.buf
		lsp_attach(client, bufnr)
	end,
})

require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "intelephense" },
	automatic_installation = true,
})

require("mason-lspconfig").setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			settings = {
				-- Add any server-specific settings here, like for `lua_ls` or `intelephense`
			},
		})
	end,
})

-- Example of server-specific settings for `lua_ls`
require("lspconfig").lua_ls.setup({
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim", "require" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

-- Example of server-specific settings for `intelephense`
require("lspconfig").intelephense.setup({
	settings = {
		intelephense = {
			files = {
				maxSize = 5000000,
				exclude = {
					"**/node_modules/**",
					"**/vendor/**",
				},
			},
			diagnostics = {
				enable = true,
				undefinedTypes = false,
				undefinedMethods = false,
				undefinedProperties = false,
				undefinedFunctions = false,
			},
			telemetry = {
				enable = false,
			},
		},
	},
})
-- < LANGUAGE SERVER PROTOCOL (LSP)

-- Set PHP file-specific options
vim.api.nvim_create_autocmd("FileType", {
	pattern = "php",
	callback = function()
		vim.bo.commentstring = "// %s"
	end,
})
