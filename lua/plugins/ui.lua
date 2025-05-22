-- theme
require("kanagawa").setup({
    compile = true,   -- enable compiling the colorscheme
    undercurl = true, -- enable undercurls
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true },
    statementStyle = { bold = true },
    typeStyle = {},
    transparent = false,   -- do not set background color
    dimInactive = false,   -- dim inactive window `:h hl-NormalNC`
    terminalColors = true, -- define vim.g.terminal_color_{0,17}
    colors = {             -- add/modify theme and palette colors
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
    },
    overrides = function(colors) -- add/modify highlights
        return {}
    end,
    background = {     -- map the value of 'background' option to a theme
        dark = "wave", -- wave / lotus / dragon
    },
})
-- setup must be called before loading
vim.cmd("colorscheme kanagawa")

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

require("neoscroll").setup({
    mappings = {
        -- <C-b>: Scroll one screen backward.
        -- <C-f>: Scroll one screen forward.
        -- <C-d>: Scroll half a screen downward.
        -- <C-u>: Scroll half a screen upward.
        -- <C-e>: Scroll the screen downward by one line.
        -- <C-y>: Scroll the screen upward by one line.
        -- zz: Center the current line in the middle of the screen.
        -- zt: Move the current line to the top of the screen.
        -- zb: Move the current line to the bottom of the screen.
        "<C-u>",
        "<C-d>",
        "<C-b>",
        "<C-f>",
        "<C-y>",
        "<C-e>",
        "zt",
        "zz",
        "zb",
    },
    hide_cursor = true,          -- Hide cursor while scrolling
    stop_eof = true,             -- Stop at <EOF> when scrolling downwards
    respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
    easing = "linear",           -- Default easing function
    pre_hook = nil,              -- Function to run before the scrolling animation starts
    post_hook = nil,             -- Function to run after the scrolling animation ends
    performance_mode = true,     -- Disable "Performance Mode" on all buffers.
    ignored_events = {           -- Events ignored while scrolling
        "WinScrolled",
        "CursorMoved",
    },
})
-- > SYMBOLS
-- Set up lualine using the same theme colors
local function get_current_function_treesitter()
    local ts_utils = require('nvim-treesitter.ts_utils')
    local current_node = ts_utils.get_node_at_cursor()

    while current_node do
        if current_node:type() == 'function_declaration' or
            current_node:type() == 'method_definition' or
            current_node:type() == 'function_definition' then
            local name_node = current_node:field('name')[1]
            if name_node then
                local name = vim.treesitter.get_node_text(name_node, 0)
                return name
            end
        end
        current_node = current_node:parent()
    end
end
require("lualine").setup({
    options = {
        globalstatus = true,
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
    },
    sections = {
        lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
        lualine_b = { "branch", "diff", get_current_function_treesitter, "filename" },
        lualine_c = { "aerial" },
        lualine_x = { "lsp_status", "encoding", "filetype" },
        lualine_y = {},
        lualine_z = { { "selectioncount", separator = { right = "" }, left_padding = 2 } },
    },
})
-- < SYMBOLS
-- < UI EHANCEMENT
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false
vim.opt.relativenumber = true
vim.opt.autoindent = true -- Copy indent from the current line when starting a new one
vim.opt.number = true
vim.opt.autoread = true
vim.cmd([[
  autocmd FocusGained,BufEnter * checktime
]])
