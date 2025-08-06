-- session.lua contain configurations for code sessions
-- > SESSION
require("auto-session").setup({
    lsp_stop_on_restore = true,
})
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions"
-- < SESSION
