-- for WSL
vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
        ['+'] = 'clip.exe',
        ['*'] = 'clip.exe',
    },
    paste = {
        ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
}

-- for nvimtree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- Set search to be case insensitive
vim.opt.ignorecase = true

-- Optional: Enable smartcase for smarter searching
-- (Searches are case insensitive unless the pattern contains uppercase)
vim.opt.smartcase = true


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

-- Load keymaps and plugins
require("plugins")
require("keymaps")
require("plugins.ui")
require("plugins.lsp")
require("plugins.editor")
require("plugins.terminal")
require("plugins.git")
require("plugins.debug")
require("plugins.testing")
require("plugins.session")
