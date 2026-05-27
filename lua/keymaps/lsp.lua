-- lsp.lua contains LSP/diagnostic helper functions

local M = {}

M.show_diagnostic_source = function()
    local winnr = vim.api.nvim_get_current_win()
    local bufnr = vim.api.nvim_win_get_buf(winnr)
    local diagnostics = vim.diagnostic.get(bufnr)
    local pos = vim.api.nvim_win_get_cursor(winnr)
    local lnum = pos[1] - 1

    local match_found = false
    for _, diag in ipairs(diagnostics) do
        if diag.lnum == lnum then
            local client = vim.lsp.get_client_by_id(diag.source)
            local source_name = client and client.name or diag.source
            print(string.format("Diagnostic from LSP server: %s", source_name))
            match_found = true
        end
    end

    if not match_found then
        print("No diagnostics found at current line.")
    end
end

local function inspect_current_buffer()
    local buf = vim.api.nvim_get_current_buf()
    local win = vim.api.nvim_get_current_win()

    local all_vars = vim.b[buf]
    local filtered_vars = {}
    for k, v in pairs(all_vars) do
        if type(v) == "string" or type(v) == "number" or type(v) == "boolean" then
            filtered_vars[k] = v
        end
    end

    local info = {
        buffer_id    = buf,
        window_id    = win,
        buffer_name  = vim.api.nvim_buf_get_name(buf),
        buffer_type  = vim.bo[buf].buftype,
        file_type    = vim.bo[buf].filetype,
        syntax       = vim.fn.getbufvar(buf, "&syntax"),
        window_type  = vim.fn.win_gettype(win),
        buffer_vars  = filtered_vars,
        is_listed    = vim.bo[buf].buflisted,
        is_modified  = vim.bo[buf].modified,
        is_readonly  = vim.bo[buf].readonly,
    }

    print("=== BUFFER/WINDOW INFO ===")
    print(string.format("Buffer ID: %d",    info.buffer_id))
    print(string.format("Window ID: %d",    info.window_id))
    print(string.format("Buffer Name: %s",  info.buffer_name))
    print(string.format("Buffer Type: %s",  info.buffer_type))
    print(string.format("File Type: %s",    info.file_type))
    print(string.format("Syntax: %s",       info.syntax))
    print(string.format("Window Type: %s",  info.window_type))
    print(string.format("Listed: %s",       tostring(info.is_listed)))
    print(string.format("Modified: %s",     tostring(info.is_modified)))
    print(string.format("Readonly: %s",     tostring(info.is_readonly)))

    if next(info.buffer_vars) then
        print("\n=== BUFFER VARIABLES ===")
        for k, v in pairs(info.buffer_vars) do
            print(string.format("%s: %s", k, tostring(v)))
        end
    end

    return info
end

vim.api.nvim_create_user_command("InspectBuffer", function()
    inspect_current_buffer()
end, { desc = "Show detailed info about current buffer/window" })

return M
