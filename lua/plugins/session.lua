-- session.lua contain configurations for code sessions
-- > SESSION
require("auto-session").setup({
    cwd_change_handling = false,
})
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions"
-- < SESSION
