-- tools.lua contain configurations for tools that extend nvim's ability

local keymaps = require("keymaps")

require("gitsigns").setup({})

require("toggleterm").setup({
    direction = "float",
    float_opts = {
        border = "curved",
        title_pos = 'right',
    },
    winbar = {
        enabled = true,
    },
    size = 15,           -- Default terminal size
    persist_size = true, -- Keep the size between opens
    autochdir = true,
})

require("auto-session").setup({
    auto_restore_last_session = false,
    cwd_change_handling = true,
    pre_cwd_changed_cmds = {
        "silent %bwipeout!",
    },
})

require("mini.files").setup({
    content = {
        -- show all files, including dotfiles
        filter = function(_)
            return true
        end,
    },
    mappings = keymaps.mappings.minifiles,
    options = {
        permanent_delete = true,
        use_as_default_explorer = true,
    },
    max_name_length = 22,
    windows = {
        max_number = math.huge,
        preview = false,
        width_focus = 50,
        width_nofocus = 15,
        width_preview = 25,
    },
})

local searchArgs = "--no-ignore --hidden"
local function generateExcludeOpts()
    local excludeFolders = {
        ".devenv",
        ".direnv",
        ".git",
        ".terraform",
        "build",
        "coverage",
        "dist",
        "node_modules",
        "out",
        "tmp",
        "vendor",
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
            .. "--silent --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
    },
    mappings = keymaps.mappings.fzflua,
})

require("telescope").setup({
    defaults = {
        find_command = { "rg", "--files" },
        layout_strategy = "vertical",
        layout_config = {
            width = 0.8,
            height = 0.9,
            prompt_position = "bottom",
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
            "--hidden",
            "--no-ignore",
        },
    },
    pickers = {
        find_files = {
            hidden = true,
            no_ignore = true,
        },
    },
    extensions = {},
})

require("telescope").load_extension("frecency") -- recent opened files
require("telescope").load_extension("neoclip")  -- clipboard
