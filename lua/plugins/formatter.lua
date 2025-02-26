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
require("conform").setup({
    -- Define formatters for specific filetypes
    -- log_level = vim.log.levels.DEBUG,
    formatters_by_ft = {
        go = { "goimports", "gofumpt" },
    },
    default_format_opts = {
        lsp_format = "fallback",
    },
    -- Format on save
    format_on_save = {
        timeout_ms = 5000,
        lsp_format = "fallback",
    },
})
-- < FORMATTER
