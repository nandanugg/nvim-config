-- Set PHP file-specific options
vim.api.nvim_create_autocmd("FileType", {
    pattern = "sql",
    callback = function()
        vim.bo.commentstring = "-- %s"
    end,
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "php",
    callback = function()
        vim.bo.commentstring = "// %s"
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "terraform",
    callback = function()
        vim.bo.commentstring = "# %s"
    end,
})

-- Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        vim.lsp.buf.format({
            timeout_ms = 5000,
            filter = function(client)
                -- if vim.bo.filetype == "php" then
                --     return client.name == "null-ls"
                -- end
                return true
            end,
            async = false,
        })
    end,
})
-- < FORMATTER
