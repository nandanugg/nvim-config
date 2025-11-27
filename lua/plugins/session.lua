-- session.lua contain configurations for code sessions
require("auto-session").setup({
    auto_restore_last_session = true,
    cwd_change_handling = true
})
-- local persistence = require("persistence")
-- persistence.setup({
--     dir = vim.fn.stdpath("state") .. "/sessions/",
--     need = 1,
--     branch = true, -- use git branch to save session
-- })
--
-- vim.api.nvim_create_autocmd("VimEnter", {
--     callback = function()
--         if vim.fn.argc() == 0 then
--             persistence.load()
--         end
--     end,
-- })
-- vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions"
-- < SESSION
