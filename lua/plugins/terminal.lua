-- > TERMINAL
require("toggleterm").setup({
	open_mapping = [[<c-\><c-\>]],
	direction = "horizontal", -- Default direction
	size = 15, -- Default terminal size
	persist_size = true, -- Keep the size between opens
	autochdir = true,
})
-- < TERMINAL
