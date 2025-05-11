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

-- TailwindCSS colorizer setup
local tailwindcss = require("tailwindcss-colorizer-cmp")
tailwindcss.setup({
    color_square_width = 2,
})

-- > CODE COMPLETIONS (CMP)
local blinkCmp = require("blink.cmp")
blinkCmp.setup({
    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- See the full "keymap" documentation for information on defining your own keymap.
    keymap = { preset = "enter" },
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
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "intelephense" },
    automatic_installation = true,
})
local server_configs = {
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
    yamlls = {
        settings = {
            yaml = {
                schemas = {
                    ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
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

require("mason-lspconfig").setup {
    automatic_enable = false
}

--  LANGUAGE SERVER PROTOCOL (LSP)
