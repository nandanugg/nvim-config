-- lsp.lua contain configurations for lsp / formatter configuration




local keymaps = require("keymaps")
-- > LANGUAGE PARSER
require("nvim-treesitter.configs").setup({
    ignore_install = {},
    modules = {},
    ensure_installed = {
        -- web dev
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "astro",
        "vue",
        "svelte",
        "graphql",
        -- backend dev
        "go",
        "gomod",
        "gosum",
        "terraform",
        "python",
        "java",
        "php",
        "phpdoc",
        "nginx",
        "nix",
        "dockerfile",
        "sql",
        "bash",
        -- config dev
        "lua",
        "json",
        "jsonc",
        "yaml",
        "csv",
        "markdown",
        "markdown_inline",
        "git_config",
        "regex",
        "vim",
        "tmux",
        "ssh_config",
    },
    sync_install = false,
    auto_install = false,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
        enable = true,
        keymaps = keymaps.mappings.treesitter.incremental_selection_keymaps,
    },
})
-- < LANGUAGE PARSER

-- > MASON
require("mason").setup({
    ui = {
        border = "rounded",
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
})
-- < MASON

-- > CODE COMPLETIONS (CMP)
local blinkCmp = require("blink.cmp")
blinkCmp.setup({
    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- See the full "keymap" documentation for information on defining your own keymap.
    keymap = vim.tbl_deep_extend("force", { preset = "enter" }, keymaps.mappings.blinkCmp),
    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
            treesitter_highlighting = true,
        },
        menu = {
            auto_show = function(ctx)
                return ctx.mode ~= "cmdline"
            end,
        },
        accept = {},
        trigger = {
            show_on_insert_on_trigger_character = true
        },
    },
    signature = { enabled = true },
    fuzzy = {
        use_frecency = true,
        use_proximity = true,
    },
    appearance = {
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
    },
})
-- < CODE COMPLETIONS (CMP)

-- > LSP SETUP
local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")

-- Install servers via Mason
mason_lspconfig.setup({
    automatic_enable = true,
    ensure_installed = {
        "lua_ls",
        "intelephense",
        "gopls",
        "ts_ls",
        "eslint",
        "terraformls",
        "yamlls",
        "jsonls",
        "docker_compose_language_service",
        "astro",
        "tailwindcss",
    },
})

-- Define your server-specific configurations
local server_configs = {
    tailwindcss = {},
    lua_ls = {
        filetypes = { "lua" },
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT",
                },
                diagnostics = {
                    globals = { "vim", "require" },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    },
    intelephense = {
        filetypes = { "php" },
        settings = {
            intelephense = {
                files = {
                    maxSize = 5000000,
                    exclude = {
                        "**/node_modules/**",
                        "**/vendor/**",
                    },
                },
                diagnostics = {
                    enable = true,
                    undefinedTypes = false,
                    undefinedMethods = false,
                    undefinedProperties = false,
                    undefinedFunctions = false,
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    },
    gopls = {},
    astro = {},
    ts_ls = {
        filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" }
    },
    eslint = {},
    terraformls = {},
    jsonls = {
        filetypes = { "json", "jsonc" },
        settings = {
            json = {
                schemas = {
                    {
                        fileMatch = { "package.json" },
                        url = "https://json.schemastore.org/package.json"
                    },
                    {
                        fileMatch = { "tsconfig*.json" },
                        url = "https://json.schemastore.org/tsconfig.json"
                    },
                    {
                        fileMatch = {
                            ".prettierrc",
                            ".prettierrc.json",
                            "prettier.config.json"
                        },
                        url = "https://json.schemastore.org/prettierrc.json"
                    },
                    {
                        fileMatch = { ".eslintrc", ".eslintrc.json" },
                        url = "https://json.schemastore.org/eslintrc.json"
                    },
                    {
                        fileMatch = { ".babelrc", ".babelrc.json", "babel.config.json" },
                        url = "https://json.schemastore.org/babelrc.json"
                    },
                    {
                        fileMatch = { "lerna.json" },
                        url = "https://json.schemastore.org/lerna.json"
                    },
                    {
                        fileMatch = { "now.json", "vercel.json" },
                        url = "https://json.schemastore.org/now.json"
                    },
                    {
                        fileMatch = {
                            ".stylelintrc",
                            ".stylelintrc.json",
                            "stylelint.config.json"
                        },
                        url = "http://json.schemastore.org/stylelintrc.json"
                    }
                }
            }
        }
    },
    yamlls = {
        settings = {
            yaml = {
                schemas = {
                    ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json "] =
                    "/docker-compose*.yml",
                },
            },
        },
    },
    docker_compose_language_service = {
        filetypes = { "yaml" },
        root_dir = function(fname)
            return lspconfig.util.root_pattern("docker-compose.yml", "docker-compose.yaml")(fname)
        end,
    },
}

-- Apply configurations to each server
for server, config in pairs(server_configs) do
    vim.lsp.config(server, config)
end
--  LANGUAGE SERVER PROTOCOL (LSP)

-- Format on save
require("conform").setup({
    -- Define formatters for specific filetypes
    log_level = vim.log.levels.DEBUG,
    formatters_by_ft = {
        go = { "goimports", "gofumpt" },
        javascript = { "prettier", "eslint_d", stop_after_first = false },
        astro = { "prettier", stop_after_first = false },
        json = { "jq" },
    },
    default_format_opts = {
        lsp_format = "fallback",
    },
    formatters = {
        prettier = {
            prepend_args = { "-w" },
        }
    },
    notify_on_error = true,
    notify_no_formatters = true,
    format_on_save = {
        timeout_ms = 10000,
        lsp_format = "fallback",
    },
})
-- < FORMATTER
