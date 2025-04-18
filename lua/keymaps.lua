local M = {}

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- mason
vim.keymap.set("n", "<Leader>cm", ":Mason<CR>", { noremap = true, silent = true })

-- basic functionality
vim.keymap.set("n", "<S-q>", ':q<CR>', { noremap = true, silent = true })
vim.keymap.set("n", "<S-y>", '"+yy', { noremap = true, silent = true })
vim.keymap.set("v", "<S-y>", '"+y', { noremap = true, silent = true })
vim.keymap.set("n", "<Esc>", ":noh<CR><Esc>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>wf", function()
    vim.g.disable_autoformat = true
    vim.cmd("write")
    vim.g.disable_autoformat = false
end, { desc = "Write without formatting" })

-- Explorer
vim.keymap.set("n", "<Leader>ke", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
-- searching
vim.keymap.set("n", "<Leader>kk", "<Cmd>FzfLua files<CR>", {})
vim.keymap.set("n", "<Leader>ko", "<Cmd>FzfLua oldfiles<CR>")
vim.keymap.set("n", "<Leader>kg", "<cmd>FzfLua live_grep<CR>")
vim.keymap.set("v", "<Leader>kf", "<cmd>FzfLua grep_cword<CR>")
vim.keymap.set("n", "<Leader>kb", "<Cmd>FzfLua buffers<CR>")
vim.keymap.set("n", "<Leader>km", "<cmd>Telescope marks<CR>")
vim.keymap.set("n", "<Leader>ks", "<cmd>FzfLua lsp_document_symbols<CR>", { desc = "Find Symbols" })
vim.keymap.set("n", "<Leader>kp", "<cmd>Telescope neoclip<CR>")
vim.keymap.set("n", "<Leader>ku", vim.cmd.UndotreeToggle)
M.mappings = {
    treesitter = {
        incremental_selection_keymaps = {
            -- h: nvim-treesitter-incremental-selection-mod
            init_selection = "gnn",    -- Start selection
            node_incremental = "gna",  -- Increment to the next node
            scope_incremental = "gng", -- Increment to the next scop
            node_decremental = "gnx",  -- Decrement the selectio
        },
    },
    telescope = {
        -- :h telescope.mappings
        i = {},
        n = {},
    },
    -- neotree = {
    -- 	-- :h neotree-mappings
    -- 	["<C-y>"] = function(state)
    -- 		local node = state.tree:get_node()
    -- 		if node then
    -- 			local full_path = node:get_id()
    -- 			local cwd = vim.fn.getcwd()
    -- 			local relative_path = vim.fn.fnamemodify(full_path, ":." .. cwd)
    --
    -- 			vim.fn.setreg("+", relative_path) -- Yank to the system clipboard
    -- 			vim.notify("Yanked: " .. relative_path, vim.log.levels.INFO)
    -- 		else
    -- 			vim.notify("No file selected to yank", vim.log.levels.WARN)
    -- 		end
    -- 	end,
    -- },
    -- zc - Close/fold the current block
    -- zo - Open/unfold the current block
    -- za - Toggle fold/unfold at the cursor
    -- zM - Close all folds
    -- zR - Open all folds
}

-- buffers
vim.keymap.set("n", "<S-r>", ":resize +5<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-f>", ":resize -5<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-y>", ":vertical resize +5<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-u>", ":vertical resize -5<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-t>", ":enew<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-w><S-z>", ":MaximizerToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-w><S-w>", ":Bdelete<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-w><S-o>", ":BufferLineCloseOthers<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-w><S-v>", ":vsplit<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-l>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-h>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-k>", ":TSJSplit<CR>", { noremap = true, silent = true })

-- marks
-- mx           Toggle mark 'x' and display it in the leftmost column
-- dmx          Remove mark 'x' where x is a-zA-Z
--
-- m,           Place the next available mark
-- m.           If no mark on line, place the next available mark. Otherwise, remove (first) existing mark.
-- m-           Delete all marks from the current line
-- m<Space>     Delete all marks from the current buffer
-- ]`           Jump to next mark
-- [`           Jump to prev mark
-- ]'           Jump to start of next line containing a mark
-- ['           Jump to start of prev line containing a mark
-- `]           Jump by alphabetical order to next mark
-- `[           Jump by alphabetical order to prev mark
-- ']           Jump by alphabetical order to start of next line having a mark
-- '[           Jump by alphabetical order to start of prev line having a mark
-- m/           Open location list and display marks from current buffer
--
-- m[0-9]       Toggle the corresponding marker !@#$%^&*()
-- m<S-[0-9]>   Remove all markers of the same type
-- ]-           Jump to next line having a marker of the same type
-- [-           Jump to prev line having a marker of the same type
-- ]=           Jump to next line having a marker of any type
-- [=           Jump to prev line having a marker of any type
-- m?           Open location list and display markers from current buffer
-- m<BS>        Remove all markers

-- lsp specific
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "gd", ":FzfLua lsp_definitions<CR>", opts)
vim.keymap.set("n", "gD", ":FzfLua diagnostics_documentCR", opts)
vim.keymap.set("n", "gf", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "gt", ":FzfLua lsp_typedefs<CR>", opts)
vim.keymap.set("n", "gu", ":FzfLua lsp_references<CR>", opts)
vim.keymap.set("n", "gU", ":FzfLua lsp_implementations<CR>", opts)
vim.keymap.set("n", "ga", vim.lsp.buf.code_action, opts)
vim.keymap.set("n", "gr", vim.lsp.buf.rename, opts)
vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)

-- git
vim.keymap.set("n", "<Leader>gg", ":Git<CR>", opts)
vim.keymap.set("n", "<Leader>gdd", ":Gvdiffsplit!<CR>", opts)
vim.keymap.set("n", "<Leader>gdh", ":diffget //2<CR>", opts)
vim.keymap.set("n", "<Leader>gdl", ":diffget //3<CR>", opts)
local gitsigns = require("gitsigns")
vim.keymap.set("n", "<Leader>gh", gitsigns.preview_hunk, opts)
vim.keymap.set("n", "<Leader>gr", gitsigns.reset_hunk, opts)
vim.keymap.set("n", "<Leader>gb", gitsigns.blame, opts)
vim.keymap.set("n", "]h", "<cmd>Gitsigns next_hunk<CR>", {})
vim.keymap.set("n", "[h", "<cmd>Gitsigns prev_hunk<CR>", {})

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
vim.keymap.set("n", "<C-\\><C-1>", [[<Cmd>1ToggleTerm<CR>]], { noremap = true, silent = true })
vim.keymap.set("n", "<C-\\><C-2>", [[<Cmd>2ToggleTerm<CR>]], { noremap = true, silent = true })
vim.keymap.set("n", "<C-\\><C-3>", [[<Cmd>3ToggleTerm<CR>]], { noremap = true, silent = true })
vim.keymap.set("t", "<C-\\><C-1>", [[<Cmd>1ToggleTerm<CR>]], { noremap = true, silent = true })
vim.keymap.set("t", "<C-\\><C-2>", [[<Cmd>2ToggleTerm<CR>]], { noremap = true, silent = true })
vim.keymap.set("t", "<C-\\><C-3>", [[<Cmd>3ToggleTerm<CR>]], { noremap = true, silent = true })

-- testing
local neotest = require("neotest")
vim.keymap.set("n", "<Leader>tt", function() neotest.run.run() end, { noremap = true })
vim.keymap.set("n", "<Leader>ta", function() neotest.run.run(vim.fn.expand("%")) end, { noremap = true })
vim.keymap.set("n", "<Leader>th", function() neotest.output.open({ enter = true }) end, { noremap = true })
vim.keymap.set("n", "<Leader>tq", ":Neotest summary<CR>", { noremap = true })
vim.keymap.set("n", "<Leader>tl", ":Neotest output-panel<CR>", { noremap = true })

-- debugging
vim.keymap.set("n", "<Leader>ds", function()
    require("dap").continue()
end)
vim.keymap.set("n", "<Leader>dn", function()
    require("dap").step_over()
end)
vim.keymap.set("n", "<Leader>di", function()
    require("dap").step_into()
end)
vim.keymap.set("n", "<Leader>do", function()
    require("dap").step_out()
end)
vim.keymap.set("n", "<Leader>dq", function()
    require("dap").terminate()
end)
vim.keymap.set("n", "<Leader>dt", function() neotest.run.run({ strategy = "dap" }) end, { noremap = true })
vim.keymap.set("n", "<Leader>db", '<cmd>lua require("dap").toggle_breakpoint()<CR>', {})
vim.keymap.set("n", "<Leader>du", '<cmd>lua require("dapui").toggle()<CR>', {})
vim.keymap.set("n", "<Leader>dh", '<cmd>lua require("dapui").eval()<CR>', {})
vim.keymap.set("n", "<Leader>di", ":Telescope dap list_breakpoints<CR>", {})
vim.keymap.set("n", "<Leader>df", ":Telescope dap frames<CR>", {})
vim.keymap.set("n", "<Leader>dl", ":DapShowLog<CR>", {})
vim.keymap.set("n", "<Leader>dw", function()
    require("dap.ui.widgets").hover()
end)

return M
