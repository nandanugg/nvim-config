-- session.lua contain configurations for code sessions
-- > SESSION
local function load_session()
    local persistence = require("persistence")

    -- Restore the session for the current directory
    persistence.load()
end

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        -- Only load the session if no files were passed on the command line
        if vim.fn.argc() == 0 then
            load_session()
        end
    end,
})
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions"
-- < SESSION
