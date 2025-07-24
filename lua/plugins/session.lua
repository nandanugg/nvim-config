-- session.lua contain configurations for code sessions
-- > SESSION
require("auto-session").setup({
    auto_restore_last_session = true,
    show_auto_restore_notif = true,
    lsp_stop_on_restore = true,
})
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions"
-- < SESSION
