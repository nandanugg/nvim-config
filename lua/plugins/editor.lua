local keymaps = require("keymaps")

-- > FILE EXPLORER
require("nvim-tree").setup({
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        side = "right",
        width = 40,
    },
    renderer = {
        group_empty = true,
        highlight_opened_files = "icon",
    },
    filters = {
        dotfiles = false,
    },
    update_focused_file = {
        enable = true,
    },
})
-- < FILE EXPLORER
-- > BUFFER TABS
require("bufferline").setup({
    options = {
        diagnostics = "nvim_lsp", -- Show LSP diagnostics in the bufferline
        themable = true,
        separator_style = "slant",
        tab_size = 13,
        show_buffer_close_icons = false,
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
        end,
    },
    highlights = {},
})
-- > BUFFER TABS

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

local searchArgs = "--no-ignore --hidden"
local function generateExcludeOpts()
    local excludeFolders = {
        ".git",
        ".devenv",
        ".direnv",
        ".terraform",
        "node_modules",
        "vendor",
        "dist",
        "build",
        "out",
        "coverage",
        "tmp",
    }
    local find_excludes = table.concat(
        vim.tbl_map(function(dir)
            return string.format("-not -path '*/%s/*'", dir)
        end, excludeFolders),
        " "
    )

    local rg_excludes = table.concat(
        vim.tbl_map(function(dir)
            return string.format("--glob '!%s'", dir)
        end, excludeFolders),
        " "
    )

    local fd_excludes = table.concat(
        vim.tbl_map(function(dir)
            return string.format("-E '%s'", dir)
        end, excludeFolders),
        " "
    )
    local grep_excludes = table.concat(
        vim.tbl_map(function(dir)
            return string.format("--exclude-dir='%s'", dir)
        end, excludeFolders),
        " "
    )

    return {
        find = find_excludes,
        rg = rg_excludes,
        fd = fd_excludes,
        grep = grep_excludes,
    }
end

local ignoredPath = generateExcludeOpts()

-- > SEARCH
require("fzf-lua").setup({
    "telescope",
    files = {
        find_opts = searchArgs .. " " .. ignoredPath.find .. " -type f -not -path '*/\\.git/*' -printf '%P\\n'",
        rg_opts = searchArgs .. " " .. ignoredPath.rg .. " --color=never --files --follow",
        fd_opts = searchArgs .. " " .. ignoredPath.fd .. " --color=never --type f --follow",
    },
    winopts = {
        width = 0.8,
        height = 0.9,
        preview = {
            layout = "vertical",
            delay = 150,
            winopts = { number = false },
        },
    },
    grep = {
        grep_opts = searchArgs
            .. " "
            .. searchArgs
            .. " "
            .. ignoredPath.grep
            .. "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp -e",
        rg_opts = searchArgs
            .. " "
            .. searchArgs
            .. " "
            .. ignoredPath.rg
            .. "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
    },
})
require("telescope").setup({
    defaults = {
        find_command = { "rg", "--files" },
        -- sorting_strategy = "ascending", -- Options: "ascending" or "descending"
        layout_strategy = "vertical",   -- Choose "horizontal", "vertical", "center", "flex"
        layout_config = {
            width = 0.8,                -- Width as a proportion of the screen (e.g., 80% of the screen)
            height = 0.9,               -- Height as a proportion of the screen
            prompt_position = "bottom", -- Position of the prompt; can be "top" or "bottom"

            -- horizontal = {
            -- 	preview_width = 0.5, -- Width of the preview window for horizontal layout
            -- 	mirror = false, -- Flip the results and preview positions
            -- },
            -- vertical = {
            -- 	preview_height = 0.5, -- Height of the preview window for vertical layout
            -- 	mirror = true,
            -- },
            -- center = {
            -- 	preview_cutoff = 40, -- When to switch to center layout instead of flex
            -- 	width = 0.5,
            -- 	height = 0.4,
            -- },
            -- flex = {
            -- 	flip_columns = 120, -- At this column width, Telescope will switch to vertical layout
            -- },
        },
        mappings = keymaps.mappings.telescope,
        file_ignore_patterns = {
            "%.git/",
            "%.lock",
            "%.direnv",
            "%.devenv",
            "__pycache__/",
            "node_modules/",
            "vendor/",
            "dist/",
            "build/",
            "tmp/",
        },
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",    -- Include hidden files in the search
            "--no-ignore", -- Don't respect .gitignore files
        },
    },
    pickers = {
        find_files = {
            hidden = true,    -- This will include dotfiles
            no_ignore = true, -- This will not respect .gitignore files
        },
    },
    extensions = {},
})
-- breaking down line into multiple lines
require('treesj').setup({})

require("telescope").load_extension("frecency") -- recent opened file
require("telescope").load_extension("neoclip")  -- clipboard
-- < SEARCH
