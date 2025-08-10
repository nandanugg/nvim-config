-- keymaps.lua contain configurations for keymapping
local neotest = require("neotest")
local gitsigns = require("gitsigns")
local M = {}

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"


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

-- for buffer inspection
local function inspect_current_buffer()
    local buf = vim.api.nvim_get_current_buf()
    local win = vim.api.nvim_get_current_win()

    -- Get buffer info
    local bufname = vim.api.nvim_buf_get_name(buf)
    local buftype = vim.bo[buf].buftype
    local filetype = vim.bo[buf].filetype
    local syntax = vim.fn.getbufvar(buf, '&syntax')

    -- Get window info
    local wintype = vim.fn.win_gettype(win)

    -- Get buffer variables (useful for plugin-specific vars)
    local buf_vars = {}
    local ok, vars = pcall(vim.api.nvim_buf_get_var, buf, '')
    if ok then
        for k, v in pairs(vars) do
            if type(v) == 'string' or type(v) == 'number' or type(v) == 'boolean' then
                buf_vars[k] = v
            end
        end
    end

    -- Get all buffer-local variables
    local all_vars = vim.b[buf]
    local filtered_vars = {}
    for k, v in pairs(all_vars) do
        if type(v) == 'string' or type(v) == 'number' or type(v) == 'boolean' then
            filtered_vars[k] = v
        end
    end

    -- Create info table
    local info = {
        buffer_id = buf,
        window_id = win,
        buffer_name = bufname,
        buffer_type = buftype,
        file_type = filetype,
        syntax = syntax,
        window_type = wintype,
        buffer_vars = filtered_vars,
        -- Additional useful info
        is_listed = vim.bo[buf].buflisted,
        is_modified = vim.bo[buf].modified,
        is_readonly = vim.bo[buf].readonly,
    }

    -- Pretty print the info
    print("=== BUFFER/WINDOW INFO ===")
    print(string.format("Buffer ID: %d", info.buffer_id))
    print(string.format("Window ID: %d", info.window_id))
    print(string.format("Buffer Name: %s", info.buffer_name))
    print(string.format("Buffer Type: %s", info.buffer_type))
    print(string.format("File Type: %s", info.file_type))
    print(string.format("Syntax: %s", info.syntax))
    print(string.format("Window Type: %s", info.window_type))
    print(string.format("Listed: %s", tostring(info.is_listed)))
    print(string.format("Modified: %s", tostring(info.is_modified)))
    print(string.format("Readonly: %s", tostring(info.is_readonly)))

    if next(info.buffer_vars) then
        print("\n=== BUFFER VARIABLES ===")
        for k, v in pairs(info.buffer_vars) do
            print(string.format("%s: %s", k, tostring(v)))
        end
    end

    return info
end
vim.api.nvim_create_user_command('InspectBuffer', function()
    inspect_current_buffer()
end, { desc = 'Show detailed info about current buffer/window' })



-- Explorer
local minifiles_toggle = function(...)
    if not MiniFiles.close() then
        MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
        MiniFiles.reveal_cwd()
    end
end

local set_cwd = function()
    local path = (MiniFiles.get_fs_entry() or {}).path
    if path == nil then return vim.notify('Cursor is not on valid entry') end
    vim.fn.chdir(vim.fs.dirname(path))
end

local yank_path = function()
    local path = (MiniFiles.get_fs_entry() or {}).path
    if path == nil then return vim.notify('Cursor is not on valid entry') end
    vim.fn.setreg(vim.v.register, path)
end

-- Open path with system default handler (useful for non-text files)
local ui_open = function() vim.ui.open(MiniFiles.get_fs_entry().path) end

vim.keymap.set("n", "<C-p><C-e>", minifiles_toggle,
    { noremap = true, silent = true })

-- popoup specific keymap
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
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'neotest-output',
    callback = function(args)
        local buf = args.buf
        vim.keymap.set('n', '<C-c>', "<CMD>q<CR>",
            { buffer = buf, noremap = true, silent = true })
        vim.keymap.set('n', '<Esc>', "<CMD>q<CR>",
            { buffer = buf, noremap = true, silent = true })
    end,
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'dapui_hover',
    callback = function(args)
        local buf = args.buf
        vim.keymap.set('n', '<C-c>', "<CMD>q<CR>",
            { buffer = buf, noremap = true, silent = true })
        vim.keymap.set('n', '<Esc>', "<CMD>q<CR>",
            { buffer = buf, noremap = true, silent = true })
    end,
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'dap-float',
    callback = function(args)
        local buf = args.buf
        vim.keymap.set('n', '<C-c>', "<CMD>q<CR>",
            { buffer = buf, noremap = true, silent = true })
        vim.keymap.set('n', '<Esc>', "<CMD>q<CR>",
            { buffer = buf, noremap = true, silent = true })
    end,
})

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
vim.keymap.set({ 'n', 'x', 'o' }, '<leader><leader>', '<Plug>(leap-anywhere)')

-- searching
vim.keymap.set("n", "<C-p><C-p>", "<Cmd>FzfLua files<CR>", {})
vim.keymap.set("n", "<C-p><C-o>", "<Cmd>FzfLua oldfiles<CR>")
vim.keymap.set("n", "<C-p><C-g>", "<cmd>FzfLua live_grep<CR>")
vim.keymap.set("n", "<C-p><C-w>", "<cmd>FzfLua grep_cword<CR>")
vim.keymap.set("n", "<C-p><C-b>", "<Cmd>FzfLua buffers<CR>")
vim.keymap.set("n", "<C-p><C-m>", "<cmd>Telescope marks<CR>")
vim.keymap.set("n", "<C-p><C-s>", "<cmd>FzfLua lsp_document_symbols<CR>", { desc = "Find Symbols" })
vim.keymap.set("n", "<C-p><C-x>", "<cmd>Telescope neoclip<CR>")
vim.keymap.set("n", "<C-p><C-u>", vim.cmd.UndotreeToggle)
M.mappings = {
    minifiles = {
        close       = '<C-c>',
        go_in       = '',
        go_in_plus  = 'l',
        go_out      = 'h',
        go_out_plus = 'H',
        mark_goto   = "",
        mark_set    = '',
        reset       = '<BS>',
        reveal_cwd  = '@',
        show_help   = 'g?',
        synchronize = '=',
        trim_left   = '<',
        trim_right  = '>',
    },
    treesitter = {
        incremental_selection_keymaps = {
            -- h: nvim-treesitter-incremental-selection-mod
            init_selection = "gnn",    -- Start selection
            node_incremental = "gna",  -- Increment to the next node
            scope_incremental = "gng", -- Increment to the next scop
            node_decremental = "gnx",  -- Decrement the selection
        },
    },
    blinkCmp = {
        -- :h blink-cmp-config-keymap
        ['<C-u>'] = { 'scroll_documentation_up' },
        ['<C-d>'] = { 'scroll_documentation_down' },
    },

    telescope = {
        -- :h telescope.mappings
        i = {
        },
        n = {
        },
    },
    -- zc - Close/fold the current block
    -- zo - Open/unfold the current block
    -- za - Toggle fold/unfold at the cursor
    -- zM - Close all folds
    -- zR - Open all folds
}

-- buffers
vim.keymap.set("n", "<C-i>", ":resize +5<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-o>", ":resize -5<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-S-i>", ":vertical resize +5<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-S-o>", ":vertical resize -5<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-t>", ":enew<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-z>", ":MaximizerToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-w><C-w>", ":Bdelete<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-S-w><C-S-w>", ":BufferLineCloseOthers<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-w><C-v>", ":vsplit<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-w><C-s>", ":split<CR>", { noremap = true, silent = true })
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


local opts = { noremap = true, silent = true }
-- diagnostics
vim.keymap.set("n", "gF", show_diagnostic_source, opts)
vim.keymap.set("n", "gd", ":FzfLua diagnostics_document<CR>", opts)
vim.keymap.set("n", "gf", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -2, float = true }) end, opts)
-- definitions
vim.keymap.set("n", "go", ":FzfLua lsp_definitions<CR>", opts) -- see the Definitions
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
vim.keymap.set("n", "<Leader>tt", function() neotest.run.run() end, { noremap = true })
vim.keymap.set("n", "<Leader>ta", function() neotest.run.run(vim.fn.expand("%")) end, { noremap = true })
vim.keymap.set("n", "<Leader>th", function() neotest.output.open({ enter = true }) end, { noremap = true })
vim.keymap.set("n", "<Leader>te", ":Neotest summary<CR>", { noremap = true })
vim.keymap.set("n", "<Leader>tl", function() neotest.output_panel.toggle() end, { noremap = true })
vim.keymap.set(
    "n",
    "<Leader>tx",
    function()
        neotest.run.run({ nil, strategy = "dap" })
    end,
    { noremap = true }
)

-- debugging
vim.keymap.set("n", "<C-x><C-s>", function()
    require("dap").continue()
end)
vim.keymap.set("n", "<C-x><C-n>", function()
    require("dap").step_over()
end)
vim.keymap.set("n", "<C-x><C-i>", function()
    require("dap").step_into()
end)
vim.keymap.set("n", "<C-x><C-o>", function()
    require("dap").step_out()
end)
vim.keymap.set("n", "<C-x><C-q>", function()
    require("dap").terminate()
end)
vim.keymap.set("n", "<C-x><C-b>", '<cmd>lua require("dap").toggle_breakpoint()<CR>', {})
vim.keymap.set("n", "<C-x><C-l>", '<cmd>lua require("dapui").toggle()<CR>', {})
vim.keymap.set("n", "<C-x><C-e>", ":Telescope dap list_breakpoints<CR>", {})
vim.keymap.set("n", "<C-x><C-f>", ":Telescope dap frames<CR>", {})
vim.keymap.set("n", "<C-x><C-h>", function()
    require("dap.ui.widgets").hover()
end)
vim.keymap.set("n", "<Leader>dH", '<cmd>lua require("dapui").eval()<CR>', {})

return M
