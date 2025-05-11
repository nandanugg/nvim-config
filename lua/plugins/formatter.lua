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
    log_level = vim.log.levels.DEBUG,
    formatters_by_ft = {
        go = { "goimports", "gofumpt" },
        javascript = { "prettierd", "prettierd", "eslint_d", "js_beautify", stop_after_first = true },
        json = { "jq", stop_after_first = true },
    },
    default_format_opts = {
        lsp_format = "fallback",
    },
    notify_on_error = true,
    notify_no_formatters = true,
    format_on_save = {
        timeout_ms = 5000,
        lsp_format = "fallback",
    },
})
-- < FORMATTER
