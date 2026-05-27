-- explorer.lua contains mini.files helper functions and keymaps

local minifiles_toggle = function()
    if not MiniFiles.close() then
        MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
        MiniFiles.reveal_cwd()
    end
end

local set_cwd = function()
    local path = (MiniFiles.get_fs_entry() or {}).path
    if path == nil then
        return vim.notify("Cursor is not on valid entry")
    end
    vim.fn.chdir(vim.fs.dirname(path))
end

local yank_path = function()
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

local ui_open = function()
    vim.ui.open(MiniFiles.get_fs_entry().path)
end

vim.keymap.set("n", "<C-k><C-e>", minifiles_toggle, { noremap = true, silent = true })

vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesBufferCreate",
    callback = function(args)
        local b = args.data.buf_id
        vim.keymap.set("n", "<CR>", function()
            MiniFiles.go_in({ close_on_file = true })
        end, {})
        vim.keymap.set("n", "<Right>", function()
            MiniFiles.go_in({ close_on_file = true })
        end, {})
        vim.keymap.set("n", "<Left>", function()
            MiniFiles.go_out()
        end, {})
        vim.keymap.set("n", "g~", set_cwd, { buffer = b, desc = "Set cwd" })
        vim.keymap.set("n", "gX", ui_open, { buffer = b, desc = "OS open" })
        vim.keymap.set("n", "gy", yank_path, { buffer = b, desc = "Yank path" })
    end,
})
