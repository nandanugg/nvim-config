local M = {}

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- mason
vim.keymap.set("n", "<Leader>cm", ":Mason<CR>", { noremap = true, silent = true })

-- basic functionality
vim.keymap.set("n", "<C-y>", '"+yy', { noremap = true, silent = true })
vim.keymap.set("v", "<C-y>", '"+y', { noremap = true, silent = true })
vim.keymap.set("n", "<Esc>", ":noh<CR><Esc>", { noremap = true, silent = true })

-- Explorer
vim.keymap.set("n", "<C-k>", "", { noremap = true })
vim.keymap.set("n", "<C-k><C-e>", ":Neotree toggle<CR>", { noremap = true, silent = true })
-- searching
vim.keymap.set("n", "<C-k><C-k>", "<Cmd>FzfLua files<CR>", {})
vim.keymap.set("n", "<C-k><C-o>", "<Cmd>FzfLua oldfiles<CR>")
vim.keymap.set("v", "<C-k><C-g>", "<cmd>FzfLua grep_visual<CR>")
vim.keymap.set("n", "<C-k><C-g>", "<cmd>FzfLua grep<CR>")
vim.keymap.set("n", "<C-k><C-b>", "<Cmd>FzfLua buffers<CR>")
vim.keymap.set("n", "<C-k><C-m>", "<cmd>FzfLua marks<CR>")
vim.keymap.set("n", "<C-k><C-s>", "<cmd>FzfLua lsp_document_symbols<CR>", { desc = "Find Symbols" })
vim.keymap.set("n", "<C-k><C-p>", "<Cmd>Telescope commander<CR>")
vim.keymap.set("n", "<C-k><C-h>", "<cmd>Telescope neoclip<CR>")
vim.keymap.set("n", "<C-k><C-r>", "<cmd>Telescope zoxide list<CR>")
vim.keymap.set("n", "<C-k><C-u>", vim.cmd.UndotreeToggle)
M.mappings = {
	treesitter = {
		incremental_selection_keymaps = {
			-- h: nvim-treesitter-incremental-selection-mod
			init_selection = "gnn", -- Start selection with "gnn"
			node_incremental = "gni", -- Increment to the next node with "grn"
			scope_incremental = "gns", -- Increment to the next scope with "grc"
			node_decremental = "gno", -- Decrement the selection with "grm"
		},
	},
	telescope = {
		-- :h telescope.mappings
		i = {
			["<CR>"] = "select_default",
			["<C-s>"] = "file_vsplit",
		},
		n = {},
	},
	neotree = {
		-- :h neotree-mappings
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
}

-- buffers
vim.keymap.set("n", "<S-t>", ":enew<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-w>", ":Bdelete<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-l>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-h>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
for i = 1, 9 do
	vim.keymap.set(
		"n",
		"<C-" .. i .. ">",
		"<Cmd>BufferLineGoToBuffer " .. i .. "<CR>",
		{ noremap = true, silent = true }
	)
end

-- lsp specific
local function open_in_new_buffer_and_navigate(lsp_function)
	return function()
		local params = vim.lsp.util.make_position_params()
		vim.lsp.buf_request(0, lsp_function, params, function(_, result)
			if not result or vim.tbl_isempty(result) then
				print("No result from LSP")
				return
			end

			-- Check if result is a list (can be multiple definitions)
			local target = result[1] or result

			-- Jump to the location (this will open in a new buffer if needed)
			vim.lsp.util.jump_to_location(target)
		end)
	end
end

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, opts)
vim.keymap.set("n", "gt", open_in_new_buffer_and_navigate("textDocument/typeDefinition"), opts)
vim.keymap.set("n", "gU", open_in_new_buffer_and_navigate("textDocument/implementation"), opts)
vim.keymap.set("n", "gu", require("telescope.builtin").lsp_references, opts)
vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "gD", require("telescope.builtin").diagnostics, opts)
vim.keymap.set("n", "ga", vim.lsp.buf.code_action, opts)
vim.keymap.set("n", "gr", vim.lsp.buf.rename, opts)
vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)

-- git
vim.keymap.set("n", "<C-g><C-g>", "<cmd>:LazyGit<CR>", opts)
vim.keymap.set("n", "<C-g><C-b>", "<cmd>GitBlameToggle<CR>", opts)
require("gitsigns").setup({
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		map("n", "]g", function()
			if vim.wo.diff then
				return "]g"
			end
			vim.schedule(function()
				gs.next_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		map("n", "[g", function()
			if vim.wo.diff then
				return "[g"
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })
		map("n", "<C-g><C-p>", gs.preview_hunk)
		map("n", "<C-g><C-r>", gs.reset_hunk)
		-- more options
		-- https://github.com/lewis6991/gitsigns.nvim
	end,
})

-- terminal
function _G.set_terminal_keymaps()
	if vim.bo.filetype == "toggleterm" then
		local opts = { buffer = 0 }
		vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
		vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
		vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
		vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
		vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
		vim.keymap.set("t", "<C-w>", [[<C-\><niC-n><C-w>]], opts)
	end
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
vim.keymap.set("n", "<C-\\><C-\\>", [[<Cmd>ToggleTerm<CR>]], { noremap = true, silent = true })
vim.keymap.set("t", "<C-\\><C-\\>", [[<Cmd>ToggleTerm<CR>]], { noremap = true, silent = true })
vim.keymap.set("n", "1<C-\\><C-\\>", [[<Cmd>1ToggleTerm<CR>]], { noremap = true, silent = true })
vim.keymap.set("n", "2<C-\\><C-\\>", [[<Cmd>2ToggleTerm<CR>]], { noremap = true, silent = true })
vim.keymap.set("n", "3<C-\\><C-\\>", [[<Cmd>3ToggleTerm<CR>]], { noremap = true, silent = true })
vim.keymap.set("t", "1<C-\\><C-\\>", [[<Cmd>1ToggleTerm<CR>]], { noremap = true, silent = true })
vim.keymap.set("t", "2<C-\\><C-\\>", [[<Cmd>2ToggleTerm<CR>]], { noremap = true, silent = true })
vim.keymap.set("t", "3<C-\\><C-\\>", [[<Cmd>3ToggleTerm<CR>]], { noremap = true, silent = true })

-- debugging
local neotest = require("neotest")
vim.keymap.set("n", "<C-b>", "", { noremap = true })
vim.keymap.set("n", "<C-b><C-s>", function()
	require("dap").continue()
end)
vim.keymap.set("n", "<C-b><C-n>", function()
	require("dap").step_over()
end)
vim.keymap.set("n", "<C-b><C-i>", function()
	require("dap").step_into()
end)
vim.keymap.set("n", "<C-b><C-o>", function()
	require("dap").step_out()
end)
vim.keymap.set("n", "<C-b><C-q>", function()
	require("dap").terminate()
end)
vim.keymap.set("n", "<C-b><C-b>", '<cmd>lua require("dap").toggle_breakpoint()<CR>', {})
vim.keymap.set("n", "<C-b><C-u>", '<cmd>lua require("dapui").toggle()<CR>', {})
vim.keymap.set("n", "<C-b><C-h>", '<cmd>lua require("dapui").eval()<CR>', {})
vim.keymap.set("n", "<C-b><C-i>", ":Telescope dap list_breakpoints<CR>", {})
vim.keymap.set("n", "<C-b><C-f>", ":Telescope dap frames<CR>", {})
vim.keymap.set("n", "<C-b><C-o>", ":DapShowLog<CR>", {})
vim.keymap.set("n", "<C-b><C-l>", function()
	neotest.output.open({ enter = true })
end)
vim.keymap.set("n", "<C-b><C-t>", function()
	neotest.run.run({ strategy = "dap" })
end)

vim.keymap.set("n", "<C-b><C-w>", function()
	require("dap.ui.widgets").hover()
end)

return M
