-- keymaps/init.lua — pure keybindings, no logic

local neotest = require("neotest")
local gitsigns = require("gitsigns")
local telescopeActions = require("telescope.actions")
local lsp = require("keymaps.lsp")

-- unset q (V BLOCK) for tmux
pcall(vim.keymap.del, "n", "<C-q>")
pcall(vim.keymap.del, "x", "<C-q>")
pcall(vim.keymap.del, "v", "<C-q>")
pcall(vim.keymap.del, "i", "<C-q>")

local M = {}

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("keymaps.explorer")
require("keymaps.terminal")

-- autocmds for popup windows
vim.api.nvim_create_autocmd("FileType", {
    pattern = "neotest-output",
    callback = function(args)
        vim.keymap.set("n", "q", ":q<CR>", { buffer = args.buf, noremap = true, silent = true })
    end,
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "dapui_hover",
    callback = function(args)
        vim.keymap.set("n", "q", ":q<CR>", { buffer = args.buf, noremap = true, silent = true })
    end,
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "dap-float",
    callback = function(args)
        vim.keymap.set("n", "q", ":q<CR>", { buffer = args.buf, noremap = true, silent = true })
    end,
})

-- basic
-- vim.keymap.set("n", "<C-q>", ":q<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-y>", '"+yy', { noremap = true, silent = true })
vim.keymap.set("v", "<S-y>", '"+y', { noremap = true, silent = true })
vim.keymap.set("n", "<Esc>", ":noh<CR><Esc>", { noremap = true, silent = true })
vim.api.nvim_create_user_command("W", function()
    vim.g.disable_autoformat = true
    vim.cmd("write")
    vim.g.disable_autoformat = false
end, { desc = "Write without formatting" })
vim.keymap.set("n", "<S-k>", function()
    MiniSplitjoin.toggle()
end, { noremap = true, silent = true })

-- searching
vim.keymap.set("n", "<C-k><C-k>", "<Cmd>FzfLua files<CR>", {})
vim.keymap.set("n", "<C-k><C-o>", "<Cmd>FzfLua oldfiles<CR>")
vim.keymap.set("n", "<C-k><C-g>", "<cmd>FzfLua live_grep<CR>")
vim.keymap.set("n", "<C-k><C-w>", "<cmd>FzfLua grep_cword<CR>")
vim.keymap.set("n", "<C-k><C-b>", "<Cmd>FzfLua buffers<CR>")
vim.keymap.set("n", "<C-k><C-m>", "<cmd>Telescope marks<CR>")
vim.keymap.set("n", "<C-k><C-s>", "<cmd>Navbuddy<CR>", { desc = "Find Symbols" })
vim.keymap.set("n", "<C-k><C-x>", "<cmd>Telescope neoclip<CR>")
vim.keymap.set("n", "<C-k><C-u>", vim.cmd.UndotreeToggle)

-- flash
vim.keymap.set({ "o" }, "r", function()
    require("flash").remote()
end)
vim.keymap.set({ "x", "o" }, "R", function()
    require("flash").treesitter_search()
end)
vim.keymap.set({ "n", "x", "o" }, "s", function()
    require("flash").jump()
end)
vim.keymap.set({ "n", "x", "o" }, "S", function()
    require("flash").treesitter()
end)
vim.keymap.set({ "c" }, "<c-s>", function()
    require("flash").toggle()
end)

-- buffers / windows
vim.keymap.set("n", "<C-o>", ":resize +5<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-i>", ":resize -5<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-A-o>", ":vertical resize +5<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-A-i>", ":vertical resize -5<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-t>", ":enew<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-z>", ":MaximizerToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-w><C-w>", ":Bdelete<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-A-w><C-A-w>", ":BufferLineCloseOthers<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-w><C-d>", ":vsplit<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-w><C-s>", ":split<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-h>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-A-l>", ":BufferLineMoveNext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-A-h>", ":BufferLineMovePrev<CR>", { noremap = true, silent = true })

-- diagnostics / lsp
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "gF", lsp.show_diagnostic_source, opts)
vim.keymap.set("n", "gd", ":FzfLua diagnostics_document<CR>", opts)
vim.keymap.set("n", "gf", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "ge", ":Telescope diagnostics bufnr=0<CR>", opts)
vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
end, opts)
vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump({ count = -2, float = true })
end, opts)
vim.keymap.set("n", "go", ":FzfLua lsp_definitions<CR>", opts)
vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
vim.keymap.set("n", "gu", ":FzfLua lsp_references<CR>", opts)
vim.keymap.set("n", "ga", vim.lsp.buf.code_action, opts)
vim.keymap.set("n", "gr", vim.lsp.buf.rename, opts)

-- git
vim.keymap.set("n", "<C-g><C-g>", ":Git<CR>", opts)
vim.keymap.set("n", "<C-g><C-d><C-q>", ":only<CR>", opts)
vim.keymap.set("n", "<C-g><C-d><C-d>", ":Gvdiffsplit!<CR>", opts)
vim.keymap.set("n", "<C-g><C-d><C-h>", ":diffget //2<CR>", opts)
vim.keymap.set("n", "<C-g><C-d><C-l>", ":diffget //3<CR>", opts)
vim.keymap.set("n", "<C-g><C-h>", gitsigns.preview_hunk, opts)
vim.keymap.set("n", "<C-g><C-r>", gitsigns.reset_hunk, opts)
vim.keymap.set("n", "<C-g><C-b>", gitsigns.blame, opts)
vim.keymap.set("n", "]h", "<cmd>Gitsigns next_hunk<CR>", {})
vim.keymap.set("n", "[h", "<cmd>Gitsigns prev_hunk<CR>", {})

-- terminal
vim.keymap.set({ "n", "t" }, "<C-\\><C-\\>", [[<Cmd>ToggleTerm<CR>]], { noremap = true, silent = true })
vim.keymap.set({ "n", "t" }, "<C-\\><C-q>", [[<Cmd>1ToggleTerm<CR>]], { noremap = true, silent = true })
vim.keymap.set({ "n", "t" }, "<C-\\><C-w>", [[<Cmd>2ToggleTerm<CR>]], { noremap = true, silent = true })
vim.keymap.set({ "n", "t" }, "<C-\\><C-e>", [[<Cmd>3ToggleTerm<CR>]], { noremap = true, silent = true })

-- mason
vim.keymap.set("n", "<Leader>cm", ":Mason<CR>", { noremap = true, silent = true })

-- testing
vim.keymap.set("n", "<leader>tt", function()
    neotest.run.run()
end, { noremap = true })
vim.keymap.set("n", "<leader>ta", function()
    neotest.run.run(vim.fn.expand("%"))
end, { noremap = true })
vim.keymap.set("n", "<leader>th", function()
    neotest.output.open({ enter = true })
end, { noremap = true })
vim.keymap.set("n", "<leader>ts", ":Neotest summary<CR>", { noremap = true })
vim.keymap.set("n", "<leader>te", function()
    neotest.output_panel.toggle()
end, { noremap = true })
vim.keymap.set("n", "<leader>td", function()
    neotest.run.run({ nil, strategy = "dap" })
end, { noremap = true })

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

-- plugin-facing mappings (consumed by plugin setup calls)
M.mappings = {
    minifiles = {
        close = "q",
        go_in = "",
        go_in_plus = "l",
        go_out = "h",
        go_out_plus = "H",
        mark_goto = "",
        mark_set = "",
        reset = "<BS>",
        reveal_cwd = "@",
        show_help = "g?",
        synchronize = "=",
        trim_left = "<",
        trim_right = ">",
    },
    treesitter = {
        incremental_selection_keymaps = {
            init_selection = "gnn",
            node_incremental = "gna",
            scope_incremental = "gng",
            node_decremental = "gnx",
        },
    },
    blinkCmp = {
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-k>"] = { "select_prev", "fallback_to_mappings" },
        ["<C-j>"] = { "select_next", "fallback_to_mappings" },
        ["<C-A-k>"] = { "scroll_documentation_up", "fallback" },
        ["<C-A-j>"] = { "scroll_documentation_down", "fallback" },
    },
    telescope = {
        i = {
            ["<C-j>"] = telescopeActions.move_selection_next,
            ["<C-k>"] = telescopeActions.move_selection_previous,
        },
        n = {
            ["<C-j>"] = telescopeActions.move_selection_next,
            ["<C-k>"] = telescopeActions.move_selection_previous,
        },
    },
    fzflua = {
        builtin = {
            ["<C-j>"] = "down",
            ["<C-k>"] = "up",
        },
    },
}

return M
