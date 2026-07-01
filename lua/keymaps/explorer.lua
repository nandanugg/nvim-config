-- explorer.lua contains mini.files helper functions

local M = {}

M.minifiles_toggle = function()
    if not MiniFiles.close() then
        MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
        MiniFiles.reveal_cwd()
    end
end

M.set_cwd = function()
    local path = (MiniFiles.get_fs_entry() or {}).path
    if path == nil then
        return vim.notify("Cursor is not on valid entry")
    end
    vim.fn.chdir(vim.fs.dirname(path))
end

M.yank_path = function()
    local path = (MiniFiles.get_fs_entry() or {}).path
    if path == nil then
        return vim.notify("Cursor is not on valid entry")
    end
    local relative_path = vim.fn.fnamemodify(path, ":.")
    vim.fn.setreg(vim.v.register, relative_path)
    vim.fn.setreg("+", relative_path)
    vim.fn.setreg("*", relative_path)
    vim.notify("Yanked path: " .. relative_path)
end

M.ui_open = function()
    vim.ui.open(MiniFiles.get_fs_entry().path)
end

return M
