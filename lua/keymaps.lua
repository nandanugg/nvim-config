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
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<C-k><C-k>", "<Cmd>Telescope find_files hidden=true no_ignore=true<CR>", {})
vim.keymap.set("n", "<C-k><C-o>", "<Cmd>Telescope oldfiles<CR>")
vim.keymap.set("v", "<C-k><C-g>", "<cmd>Telescope grep_string<CR>")
vim.keymap.set("n", "<C-k><C-g>", "<cmd>Telescope live_grep<CR>")
vim.keymap.set("n", "<C-k><C-'>", "<Cmd>Telescope buffers<CR>")
vim.keymap.set("n", "<C-k><C-m>", "<cmd>Telescope marks<CR>")
vim.keymap.set("n", "<C-k><C-s>", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Find Symbols" })
vim.keymap.set("n", "<C-k><C-p>", "<Cmd>Telescope commander<CR>")
vim.keymap.set("n", "<C-k><C-h>", "<cmd>Telescope neoclip<CR>")
vim.keymap.set("n", "<C-k><C-r>", "<cmd>Telescope zoxide list<CR>")
vim.keymap.set("n", "<C-k><C-u>", vim.cmd.UndotreeToggle)
M.mappings = {
	treesitter = {
		incremental_selection_keymaps = {
			-- h: nvim-treesitter-incremental-selection-mod
			init_selection = "gnn", -- Start selection
			node_incremental = "gni", -- Increment to the next node
			scope_incremental = "gns", -- Increment to the next scop
			node_decremental = "gno", -- Decrement the selectio
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
local function toggle_split_with_plugin()
	local current_win = vim.api.nvim_get_current_win()
	local windows = vim.api.nvim_tabpage_list_wins(0)

	-- If there's only one window, do nothing
	if #windows == 1 then
		return
	end

	-- Get all window information
	local wins_info = {}
	for _, win in ipairs(windows) do
		table.insert(wins_info, {
			win = win,
			buf = vim.api.nvim_win_get_buf(win),
			cursor = vim.api.nvim_win_get_cursor(win),
			width = vim.api.nvim_win_get_width(win),
			height = vim.api.nvim_win_get_height(win),
		})
	end

	-- Determine if current layout is vertical or horizontal split
	local is_vsplit = wins_info[1].width < vim.o.columns - 1

	-- Store active window index
	local active_idx = 1
	for i, info in ipairs(wins_info) do
		if info.win == current_win then
			active_idx = i
			break
		end
	end

	-- Close all windows except the first one
	for i = #windows, 2, -1 do
		vim.api.nvim_win_close(windows[i], false)
	end

	-- Create new split in opposite direction
	local cmd = is_vsplit and "split" or "vsplit"
	vim.cmd(cmd)

	-- Get the new windows after split
	local new_windows = vim.api.nvim_tabpage_list_wins(0)

	-- Restore buffers and cursor positions
	for i, win in ipairs(new_windows) do
		local info = wins_info[i]
		if info then
			vim.api.nvim_win_set_buf(win, info.buf)
			vim.api.nvim_win_set_cursor(win, info.cursor)
		end
	end

	-- Restore active window focus
	if active_idx <= #new_windows then
		vim.api.nvim_set_current_win(new_windows[active_idx])
	end
end

vim.keymap.set("n", "<S-r>", ":resize +5<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-f>", ":resize -5<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-S-r>", ":vertical resize +5<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-S-f>", ":vertical resize -5<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-t>", ":enew<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-w><S-z>", ":MaximizerToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-w><S-w>", ":Bdelete<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-w><S-v>", toggle_split_with_plugin, { noremap = true, silent = true })
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
vim.keymap.set("n", "<C-g><C-g>", ":Git<CR>", opts)
-- vim.keymap.set("n", "<C-g><C-'>", ":Git blame<CR>", opts)
vim.keymap.set("n", "<C-g><C-d>", ":Gvdiff<CR>", opts)
local gitsigns = require("gitsigns")
vim.keymap.set("n", "<C-g><C-h>", gitsigns.preview_hunk, opts)
vim.keymap.set("n", "<C-g><C-r>", gitsigns.reset_hunk, opts)
vim.keymap.set("n", "<C-g><C-'>", gitsigns.toggle_current_line_blame, opts)
vim.keymap.set("n", "]h", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
vim.keymap.set("n", "[h", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

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
vim.keymap.set("n", "<C-'>", "", { noremap = true })
vim.keymap.set("n", "<C-'><C-s>", function()
	require("dap").continue()
end)
vim.keymap.set("n", "<C-'><C-n>", function()
	require("dap").step_over()
end)
vim.keymap.set("n", "<C-'><C-i>", function()
	require("dap").step_into()
end)
vim.keymap.set("n", "<C-'><C-o>", function()
	require("dap").step_out()
end)
vim.keymap.set("n", "<C-'><C-q>", function()
	require("dap").terminate()
end)
vim.keymap.set("n", "<C-'><C-b>", '<cmd>lua require("dap").toggle_breakpoint()<CR>', {})
vim.keymap.set("n", "<C-'><C-u>", '<cmd>lua require("dapui").toggle()<CR>', {})
vim.keymap.set("n", "<C-'><C-h>", '<cmd>lua require("dapui").eval()<CR>', {})
vim.keymap.set("n", "<C-'><C-i>", ":Telescope dap list_breakpoints<CR>", {})
vim.keymap.set("n", "<C-'><C-f>", ":Telescope dap frames<CR>", {})
vim.keymap.set("n", "<C-'><C-o>", ":DapShowLog<CR>", {})
vim.keymap.set("n", "<C-'><C-l>", function()
	neotest.output.open({ enter = true })
end)
vim.keymap.set("n", "<C-'><C-t>", function()
	neotest.run.run({ strategy = "dap" })
end)

vim.keymap.set("n", "<C-'><C-w>", function()
	require("dap.ui.widgets").hover()
end)

return M
