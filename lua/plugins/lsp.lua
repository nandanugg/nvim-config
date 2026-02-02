-- lsp.lua contain configurations for lsp / formatter configuration

local keymaps = require("keymaps")
-- > LANGUAGE PARSER
--
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
    keymap = vim.tbl_deep_extend("force", { preset = "enter" }, keymaps.mappings.blinkCmp),
    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
            treesitter_highlighting = true,
        },
        ghost_text = { enabled = true },
        list = {
            preselect = true,
            auto_insert = true,
        },
        trigger = {
            show_on_insert_on_trigger_character = true,
        },
    },
    signature = { enabled = true },
    fuzzy = {
        frecency = { enabled = true },
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
        "biome",
        "eslint",
        "lua_ls",
        "intelephense",
        "gopls",
        "vtsls",
        "terraformls",
        "yamlls",
        "jsonls",
        "docker_compose_language_service",
        "astro",
        "tailwindcss",
        "jdtls",
    },
})

-- Define your server-specific configurations
local server_configs = {
    biome = {},
    eslint = {},
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
    vtsls = {
        filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
        },
    },
    terraformls = {},
    jsonls = {
        filetypes = { "json", "jsonc" },
        settings = {
            json = {
                schemas = {
                    {
                        fileMatch = { "package.json" },
                        url = "https://json.schemastore.org/package.json",
                    },
                    {
                        fileMatch = { "tsconfig*.json" },
                        url = "https://json.schemastore.org/tsconfig.json",
                    },
                    {
                        fileMatch = {
                            ".prettierrc",
                            ".prettierrc.json",
                            "prettier.config.json",
                        },
                        url = "https://json.schemastore.org/prettierrc.json",
                    },
                    {
                        fileMatch = { ".eslintrc", ".eslintrc.json" },
                        url = "https://json.schemastore.org/eslintrc.json",
                    },
                    {
                        fileMatch = { ".babelrc", ".babelrc.json", "babel.config.json" },
                        url = "https://json.schemastore.org/babelrc.json",
                    },
                    {
                        fileMatch = { "lerna.json" },
                        url = "https://json.schemastore.org/lerna.json",
                    },
                    {
                        fileMatch = { "now.json", "vercel.json" },
                        url = "https://json.schemastore.org/now.json",
                    },
                    {
                        fileMatch = {
                            "biome.json",
                        },
                        url = "https://biomejs.dev/schemas/2.2.2/schema.json",
                    },
                    {
                        fileMatch = {
                            ".stylelintrc",
                            ".stylelintrc.json",
                            "stylelint.config.json",
                        },
                        url = "http://json.schemastore.org/stylelintrc.json",
                    },
                },
            },
        },
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
    jdtls = {
        filetypes = { "java" },
        settings = {
            java = {
                configuration = {
                    runtimes = {
                        {
                            name = "JavaSE-17",
                            path = "/usr/lib/jvm/java-17-openjdk/", -- Adjust path as needed
                        },
                    },
                },
                eclipse = {
                    downloadSources = true,
                },
                maven = {
                    downloadSources = true,
                },
                implementationsCodeLens = {
                    enabled = true,
                },
                referencesCodeLens = {
                    enabled = true,
                },
                references = {
                    includeDecompiledSources = true,
                },
                format = {
                    enabled = true,
                },
                signatureHelp = { enabled = true },
                completion = {
                    favoriteStaticMembers = {
                        "org.hamcrest.MatcherAssert.assertThat",
                        "org.hamcrest.Matchers.*",
                        "org.hamcrest.CoreMatchers.*",
                        "org.junit.jupiter.api.Assertions.*",
                        "java.util.Objects.requireNonNull",
                        "java.util.Objects.requireNonNullElse",
                        "org.mockito.Mockito.*",
                    },
                    importOrder = {
                        "java",
                        "javax",
                        "com",
                        "org",
                    },
                },
                sources = {
                    organizeImports = {
                        starThreshold = 9999,
                        staticStarThreshold = 9999,
                    },
                },
                codeGeneration = {
                    toString = {
                        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                    },
                    useBlocks = true,
                },
            },
        },
    },
}

-- Apply configurations to each server
for server, config in pairs(server_configs) do
    vim.lsp.config(server, config)
    vim.lsp.enable(server)
end
--  LANGUAGE SERVER PROTOCOL (LSP)
require("mason-conform").setup({
    ignore_install = { "prettier" }, -- List of formatters to ignore during install
})
-- Format on save
require("conform").setup({
    -- Define formatters for specific filetypes
    log_level = vim.log.levels.DEBUG,
    formatters_by_ft = {
        go = { "goimports", "gofumpt" },
        javascript = { "biome", "prettier", stop_after_first = false },
        typescript = { "biome", "prettier", stop_after_first = false },
        astro = { "prettier", "biome", stop_after_first = false },
        html = { "prettier", "biome", stop_after_first = false },
        json = { "fixjson" },
        java = { "google-java-format" },
    },
    default_format_opts = {
        lsp_format = "fallback",
    },
    formatters = {
        prettier = {
            prepend_args = { "-w" },
        },
        biome = {
            command = vim.fn.stdpath("data") .. "/mason/bin/biome",
        },
    },
    notify_on_error = true,
    notify_no_formatters = true,
    format_on_save = {
        timeout_ms = 10000,
        lsp_format = "fallback",
    },
})
-- < FORMATTER
