-- Function to parse .envrc file and extract environment variables
local function parse_envrc(file_path)
    local env_vars = {}

    local success, file = pcall(io.open, file_path, "r")
    if not success or not file then
        return env_vars
    end

    local success_read, content = pcall(file.read, file, "*all")
    file:close()

    if not success_read then
        return env_vars
    end

    for line in content:gmatch("[^\r\n]+") do
        -- Trim whitespace
        line = line:match("^%s*(.-)%s*$")

        -- Skip empty lines and comments
        if line ~= "" and not line:match("^#") then
            -- More flexible pattern matching for different export formats
            local patterns = {
                "^export%s+([%w_]+)%s*=%s*(.+)$", -- export KEY=value
                "^([%w_]+)%s*=%s*(.+)$",  -- KEY=value (no export)
            }

            for _, pattern in ipairs(patterns) do
                local key, value = line:match(pattern)
                if key and value then
                    -- Handle different quote styles and expansion
                    value = value:match('^"(.*)"$') or value:match("^'(.*)'$") or value

                    -- Basic variable expansion (e.g., $HOME)
                    value = value:gsub("%$([%w_]+)", function(var)
                        return os.getenv(var) or ("$" .. var)
                    end)

                    env_vars[key] = value
                    break
                end
            end
        end
    end

    return env_vars
end

-- Function to find .envrc file in current working directory or test file directory
local function find_envrc(test_path)
    local cwd = vim.fn.getcwd()
    local test_dir = vim.fn.fnamemodify(test_path, ":h")

    -- Try current working directory first
    local envrc_path = cwd .. "/.envrc"
    if vim.fn.filereadable(envrc_path) == 1 then
        return envrc_path
    end

    -- Try test file directory
    envrc_path = test_dir .. "/.envrc"
    if vim.fn.filereadable(envrc_path) == 1 then
        return envrc_path
    end

    -- Try walking up from test directory to find .envrc
    local current_dir = test_dir
    while current_dir ~= "/" and current_dir ~= "" do
        envrc_path = current_dir .. "/.envrc"
        if vim.fn.filereadable(envrc_path) == 1 then
            return envrc_path
        end
        current_dir = vim.fn.fnamemodify(current_dir, ":h")
    end

    return nil
end

require("neotest").setup({
    log_level = vim.log.levels.DEBUG,
    run = {
        enabled = true,
        augment = function(tree, args)
            -- Get the test file path
            local test_path = tree:data().path

            -- Find .envrc file
            local envrc_path = find_envrc(test_path)

            if envrc_path then
                -- Parse environment variables from .envrc
                local envrc_vars = parse_envrc(envrc_path)

                -- Merge with existing env vars (existing ones take precedence)
                args.env = args.env or {}
                for key, value in pairs(envrc_vars) do
                    if not args.env[key] then -- Don't override existing env vars
                        args.env[key] = value
                    end
                end

                -- Optional: Print loaded env vars for debugging
                if next(envrc_vars) then
                    print("Loaded env vars from " .. envrc_path .. ":")
                    for key, value in pairs(envrc_vars) do
                        print("  " .. key .. "=" .. value)
                    end
                end
            end

            return args
        end
    },
    adapters = {
        require("neotest-golang")({})
    },
})

require("coverage").setup({
    autoreload = true,
})
