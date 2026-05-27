-- for WSL
-- vim.g.clipboard = {
--     name = 'WslClipboard',
--     copy = {
--         ['+'] =
--         'powershell.exe -c [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8; $input | Set-Clipboard',
--         ['*'] =
--         'powershell.exe -c [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8; $input | Set-Clipboard',
--     },
--     paste = {
--         ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
--         ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
--     },
--     cache_enabled = 0,
-- }
-- if clip.exe has error, run:
-- sudo sh -c 'echo :WSLInterop:M::MZ::/init:PF > /usr/lib/binfmt.d/WSLInterop.conf'
-- sudo systemctl restart systemd-binfmt
--
vim.o.cmdheight = 0

vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.tabstop = 3      -- Number of spaces a tab counts for
vim.opt.shiftwidth = 3   -- Number of spaces for indentation
vim.opt.softtabstop = 3  -- Number of spaces for <Tab> key

-- for nvimtree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- Set search to be case insensitive
vim.opt.ignorecase = true

-- Optional: Enable smartcase for smarter searching
-- (Searches are case insensitive unless the pattern contains uppercase)
vim.opt.smartcase = true
