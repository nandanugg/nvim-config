-- session.lua contain configurations for code sessions
-- > SESSION
    local persistence = require("persistence")
persistence.setup({
  dir = vim.fn.stdpath("state") .. "/sessions/",
  options = { "buffers", "curdir", "tabpages", "winsize" },
})

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.fn.argc() == 0 then
    persistence.load()
        end
    end,
})
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions"
-- < SESSION
