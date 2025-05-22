require("neotest").setup({
    log_level = vim.log.levels.DEBUG,
    adapters = {
        require("neotest-golang")({})
    },
})

require("coverage").setup({
    autoreload = true,
})
