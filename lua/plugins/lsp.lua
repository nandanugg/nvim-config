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
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "intelephense" },
    automatic_installation = true,
})

require("mason-lspconfig").setup_handlers({
    function(server_name)
        require("lspconfig")[server_name].setup({
            settings = {
                -- Add any server-specific settings here, like for `lua_ls` or `intelephense`
            },
        })
    end,
})

local lspconfig = require("lspconfig")
lspconfig.config = function(_, opts)
    for server, config in pairs(opts.servers) do
        -- passing config.capabilities to blink.cmp merges with the capabilities in your
        -- `opts[server].capabilities, if you've defined it
        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
    end
end
lspconfig.lua_ls.setup({
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
})
lspconfig.intelephense.setup({
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
})
lspconfig.yamlls.setup({
    settings = {
        yaml = {
            schemas = {
                ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
                "/docker-compose*.yml",
            },
        },
    },
})
lspconfig.docker_compose_language_service.setup({
    filetypes = { "yaml" },
    root_dir = function(fname)
        return lspconfig.util.root_pattern("docker-compose.yml", "docker-compose.yaml")(fname)
    end,
})
--  LANGUAGE SERVER PROTOCOL (LSP)
