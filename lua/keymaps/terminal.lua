-- terminal.lua contains terminal helper functions and keymaps

function _G.set_terminal_keymaps()
    if vim.bo.filetype == "toggleterm" then
        local opts = { buffer = 0 }
        vim.keymap.set("t", "<esc>",  [[<C-\><C-n>]],      opts)
        vim.keymap.set("t", "<C-h>",  [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set("t", "<C-j>",  [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set("t", "<C-k>",  [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set("t", "<C-l>",  [[<Cmd>wincmd l<CR>]], opts)
        vim.keymap.set("t", "<C-w>",  [[<C-\><C-n><C-w>]],  opts)
    end
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
