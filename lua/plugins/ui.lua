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
    colors = {          -- add/modify theme and palette colors
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
    hide_cursor = true,       -- Hide cursor while scrolling
    stop_eof = true,          -- Stop at <EOF> when scrolling downwards
    respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
    easing = "linear",        -- Default easing function
    pre_hook = nil,           -- Function to run before the scrolling animation starts
    post_hook = nil,          -- Function to run after the scrolling animation ends
    performance_mode = false, -- Disable "Performance Mode" on all buffers.
    ignored_events = {        -- Events ignored while scrolling
        "WinScrolled",
        "CursorMoved",
    },
})
-- > SYMBOLS
local function filepath()
    local fp = vim.fn.fnamemodify(vim.fn.expand("%"), ":p")
    local cwd = vim.fn.getcwd() .. "/"

    -- Remove the cwd from the beginning of the path if it exists
    if vim.startswith(fp, cwd) then
        fp = fp:sub(#cwd + 1)
    end

    -- Get available width (approximation)
    local width = vim.o.columns - 100 -- Reserve space for other components

    if #fp > width then
        -- Split the path into parts
        local parts = {}
        for part in fp:gmatch("[^/]+") do
            table.insert(parts, part)
        end

        -- Keep removing path components from the start until it fits
        while #table.concat(parts, "/") > width and #parts > 1 do
            table.remove(parts, 1)
        end

        -- Add ellipsis if we removed any components
        if #parts < #fp:gmatch("[^/]+")() then
            fp = ".../" .. table.concat(parts, "/")
        end
    end

    return fp
end
-- Set up lualine using the same theme colors
require("lualine").setup({
    options = {
        globalstatus = true,
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
    },
    sections = {
        lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
        lualine_b = { "branch", "diff", "filename" },
        lualine_c = { "aerial" },
        lualine_x = { "encoding", "filetype" },
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
