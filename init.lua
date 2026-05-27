local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
vim.opt.rtp:prepend(vim.fn.stdpath("config") .. "/lua")

require("plugins")
require("options")
require("keymaps")
require("plugins.ui")
require("plugins.tools")
require("plugins.editor")
require("plugins.debugger")
