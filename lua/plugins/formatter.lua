-- Set PHP file-specific options
vim.api.nvim_create_autocmd("FileType", {
	pattern = "php",
	callback = function()
		vim.bo.commentstring = "// %s"
	end,
})

local null_ls = require("null-ls")
local helpers = require("null-ls.helpers")
local methods = require("null-ls.methods")
--  PHP SISTER FORMATTER
local phpcsfixer_sister_dosen = helpers.make_builtin({
	name = "phpcsfixer_sister_dosen",
	meta = {
		url = "https://github.com/PHP-CS-Fixer/PHP-CS-Fixer",
		description = "Formatter for PHP files.",
	},
	method = methods.internal.FORMATTING,
	filetypes = { "php" },
	generator_opts = {
		command = "/usr/local/bin/php-cs-fixer",
		args = {
			"fix",
			"$FILENAME",
			"--using-cache=yes",
			"--config=$ROOT/.php-cs-fixer.dist.php",
		},
		to_stdin = false,
		to_temp_file = true,
	},
	factory = helpers.formatter_factory,
})
--  PHP SISTER FORMATTER

--  FORMATTER
null_ls.setup({
	sources = {
		phpcsfixer_sister_dosen,
	},
	debug = true,
})
require("mason-null-ls").setup({
	automatic_installation = true, -- Automatically install tools from mason
	automatic_setup = true, -- Automatically setup in null-ls
	handlers = {},
})

vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		vim.lsp.buf.format({
			timeout_ms = 5000,
			filter = function(client)
				if vim.bo.filetype == "php" then
					return client.name == "null-ls"
				end
				return true
			end,
			async = false,
		})
	end,
})
-- < FORMATTER
