-- > TERMINAL
require("toggleterm").setup({
    open_mapping = [[<c-\><c-\>]],
    direction = "float", -- Default direction
    float_opts = {
        border = "curved",
        title_pos = 'right',
    },
    winbar = {
        enabled = true,
    },
    size = 15,           -- Default terminal size
    persist_size = true, -- Keep the size between opens
    autochdir = true,
})
-- < TERMINAL
