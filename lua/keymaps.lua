local M = {}

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- basic functionality
vim.keymap.set("n", "<C-q>", ':q<CR>', { noremap = true, silent = true })
vim.keymap.set("n", "<S-y>", '"+yy', { noremap = true, silent = true })
vim.keymap.set("v", "<S-y>", '"+y', { noremap = true, silent = true })
vim.keymap.set("n", "<Esc>", ":noh<CR><Esc>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>wf", function()
    vim.g.disable_autoformat = true
    vim.cmd("write")
    vim.g.disable_autoformat = false
end, { desc = "Write without formatting" })

vim.keymap.set("n", "<S-k>", function() MiniSplitjoin.toggle() end, { noremap = true, silent = true, })
vim.keymap.set({ 'n', 'x', 'o' }, '\\', '<Plug>(leap-anywhere)')

-- Explorer
local minifiles_toggle = function(...)
    if not MiniFiles.close() then
        MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
        MiniFiles.reveal_cwd()
    end
end
vim.keymap.set("n", "<C-k><C-e>", minifiles_toggle,
    { noremap = true, silent = true })
-- Set focused directory as current working directory
local set_cwd = function()
    local path = (MiniFiles.get_fs_entry() or {}).path
    if path == nil then return vim.notify('Cursor is not on valid entry') end
    vim.fn.chdir(vim.fs.dirname(path))
end

-- Yank in register full path of entry under cursor
local yank_path = function()
    local path = (MiniFiles.get_fs_entry() or {}).path
    if path == nil then return vim.notify('Cursor is not on valid entry') end
    vim.fn.setreg(vim.v.register, path)
end

-- Open path with system default handler (useful for non-text files)
local ui_open = function() vim.ui.open(MiniFiles.get_fs_entry().path) end
vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    callback = function(args)
        local b = args.data.buf_id
        vim.keymap.set('n', '<CR>', function() MiniFiles.go_in({ close_on_file = true }) end, {})
        vim.keymap.set('n', '<Right>', function() MiniFiles.go_in({ close_on_file = true }) end, {})
        vim.keymap.set('n', '<Left>', function() MiniFiles.go_out() end, {})
        vim.keymap.set('n', 'g~', set_cwd, { buffer = b, desc = 'Set cwd' })
        vim.keymap.set('n', 'gX', ui_open, { buffer = b, desc = 'OS open' })
        vim.keymap.set('n', 'gy', yank_path, { buffer = b, desc = 'Yank path' })
    end,
})
-- searching
vim.keymap.set("n", "<C-k><C-k>", "<Cmd>FzfLua files<CR>", {})
vim.keymap.set("n", "<C-k><C-o>", "<Cmd>FzfLua oldfiles<CR>")
vim.keymap.set("n", "<C-k><C-g>", "<cmd>FzfLua live_grep<CR>")
vim.keymap.set("v", "<C-k><C-f>", "<cmd>FzfLua grep_cword<CR>")
vim.keymap.set("n", "<C-k><C-b>", "<Cmd>FzfLua buffers<CR>")
vim.keymap.set("n", "<C-k><C-m>", "<cmd>Telescope marks<CR>")
vim.keymap.set("n", "<C-k><C-s>", "<cmd>FzfLua lsp_document_symbols<CR>", { desc = "Find Symbols" })
vim.keymap.set("n", "<C-k><C-x>", "<cmd>Telescope neoclip<CR>")
vim.keymap.set("n", "<C-k><C-u>", vim.cmd.UndotreeToggle)
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
vim.keymap.set("n", "<C-p>", ":resize +5<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-o>", ":resize -5<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-S-p>", ":vertical resize +5<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-S-o>", ":vertical resize -5<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-t>", ":enew<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-z>", ":MaximizerToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-w><C-w>", ":Bdelete<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-S-w><C-S-w>", ":BufferLineCloseOthers<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-w><C-v>", ":vsplit<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-h>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-S-l>", ":BufferLineMoveNext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-S-h>", ":BufferLineMovePrev<CR>", { noremap = true, silent = true })

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
local function show_diagnostic_source()
    local winnr = vim.api.nvim_get_current_win()
    local bufnr = vim.api.nvim_win_get_buf(winnr)

    -- Get all diagnostics for current buffer
    local diagnostics = vim.diagnostic.get(bufnr)

    -- Get cursor position (returns [row, col], both 1-based)
    local pos = vim.api.nvim_win_get_cursor(winnr)
    local lnum = pos[1] - 1 -- convert to 0-based line number

    -- Find matching diagnostics at current line
    local match_found = false
    for _, diag in ipairs(diagnostics) do
        if diag.lnum == lnum then
            local client = vim.lsp.get_client_by_id(diag.source)
            local source_name = client and client.name or diag.source
            print(string.format("Diagnostic from LSP server: %s", source_name))
            match_found = true
        end
    end

    if not match_found then
        print("No diagnostics found at current line.")
    end
end
local opts = { noremap = true, silent = true }
-- diagnostics
-- vim.keymap.set("n", "ges", show_diagnostic_source, opts)
vim.keymap.set("n", "ge", ":FzfLua diagnostics_document<CR>", opts)
vim.keymap.set("n", "gf", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "]e", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
vim.keymap.set("n", "[e", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
-- definitions
vim.keymap.set("n", "gd", ":FzfLua lsp_definitions<CR>", opts) -- see the Definitions
vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
-- vim.keymap.set("n", "git" ":FzfLua lsp_typedefs<CR>", opts)   -- see the Type
-- vim.keymap.set("n", "gii", ":FzfLua lsp_implementations<CR>", opts) -- somehow it's the same as typedefs
vim.keymap.set("n", "gu", ":FzfLua lsp_references<CR>", opts) -- see the Usage
vim.keymap.set("n", "ga", vim.lsp.buf.code_action, opts)
vim.keymap.set("n", "gr", vim.lsp.buf.rename, opts)

-- git
vim.keymap.set("n", "<C-g><C-g>", ":Git<CR>", opts)
vim.keymap.set("n", "<C-g><C-d><C-d>", ":Gvdiffsplit!<CR>", opts)
vim.keymap.set("n", "<C-g><C-d><C-h>", ":diffget //2<CR>", opts)
vim.keymap.set("n", "<C-g><C-d><C-l>", ":diffget //3<CR>", opts)
local gitsigns = require("gitsigns")
vim.keymap.set("n", "<C-g><C-h>", gitsigns.preview_hunk, opts)
vim.keymap.set("n", "<C-g><C-r>", gitsigns.reset_hunk, opts)
vim.keymap.set("n", "<C-g><C-b>", gitsigns.blame, opts)
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

-- mason
vim.keymap.set("n", "<Leader>cm", ":Mason<CR>", { noremap = true, silent = true })

-- testing
local neotest = require("neotest")
vim.keymap.set("n", "<Leader>tt", function() neotest.run.run() end, { noremap = true })
vim.keymap.set("n", "<Leader>ta", function() neotest.run.run(vim.fn.expand("%")) end, { noremap = true })
vim.keymap.set("n", "<Leader>th", function() neotest.output.open({ enter = true }) end, { noremap = true })
vim.keymap.set("n", "<Leader>te", ":Neotest summary<CR>", { noremap = true })
vim.keymap.set("n", "<Leader>tl", function() neotest.output_panel.toggle() end, { noremap = true })
vim.keymap.set(
    "n",
    "<Leader>td",
    function()
        require("neotest").run.run({ nil, strategy = "dap" })
    end,
    { noremap = true }
)
-- vim.keymap.set("n", "<Leader>td",
--     function() neotest.run.run({ require('neotest.client').get_nearest(vim.api.nvim_buf_get_name(0), vim.api.nvim_win_get_cursor(0)[1] - 1), strategy = "dap" }) end,
--     { noremap = true })
-- vim.keymap.set("n", "<Leader>tl", ":Neotest output-panel<CR>", { noremap = true })

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
