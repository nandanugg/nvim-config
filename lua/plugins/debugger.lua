-- debugger.lua contain configurations for debugging and testing

-- > DAP
local dap = require("dap")
dap.set_log_level("TRACE")
local function clear_dap_log()
    local log_path = vim.fn.stdpath("cache") .. "/dap.log"
    local f = io.open(log_path, "w")
    if f then
        f:write("")
        f:close()
        print("DAP log cleared")
    end
end

local dapui = require("dapui")
dapui.setup({
    layouts = {
        {
            elements = {
                "scopes",
            },
            size = 10,
            position = "bottom",
        },
    },
})
require("telescope").load_extension("dap")
dap.listeners.before.attach.dapui_config = function()
    dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
    clear_dap_log()
    dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
end

require('dap-go').setup {
    dap_configurations = {
        {
            type = "go",
            name = "Attach remote",
            mode = "remote",
            request = "attach",
        },
    },
    delve = {
        path = "dlv",
        initialize_timeout_sec = 20,
        port = "${port}",
        args = {},
        build_flags = {},
        detached = vim.fn.has("win32") == 0,
        cwd = nil,
    },
    tests = {
        verbose = false,
    },
}

dap.adapters.delve = function(callback, config)
    if config.mode == 'remote' and config.request == 'attach' then
        callback({
            type = 'server',
            host = config.host or '127.0.0.1',
            port = config.port or '38697'
        })
    else
        callback({
            type = 'server',
            port = '${port}',
            executable = {
                command = 'dlv',
                args = { 'dap', '-l', '127.0.0.1:${port}', '--log', '--log-output=dap' },
                detached = vim.fn.has("win32") == 0,
            }
        })
    end
end

dap.configurations.go = {
    {
        type = "delve",
        name = "Debug",
        request = "launch",
        program = "${file}"
    },
    {
        type = "delve",
        name = "Debug test",
        request = "launch",
        mode = "test",
        program = "${file}"
    },
    {
        type = "delve",
        name = "Debug test (go.mod)",
        request = "launch",
        mode = "test",
        program = "./${relativeFileDirname}"
    }
}
-- < DAP

-- > NEOTEST
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
        line = line:match("^%s*(.-)%s*$")

        if line ~= "" and not line:match("^#") then
            local patterns = {
                "^export%s+([%w_]+)%s*=%s*(.+)$",
                "^([%w_]+)%s*=%s*(.+)$",
            }

            for _, pattern in ipairs(patterns) do
                local key, value = line:match(pattern)
                if key and value then
                    value = value:match('^"(.*)"$') or value:match("^'(.*)'$") or value
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

local function find_envrc(test_path)
    local cwd = vim.fn.getcwd()
    local test_dir = vim.fn.fnamemodify(test_path, ":h")

    local envrc_path = cwd .. "/.envrc"
    if vim.fn.filereadable(envrc_path) == 1 then
        return envrc_path
    end

    envrc_path = test_dir .. "/.envrc"
    if vim.fn.filereadable(envrc_path) == 1 then
        return envrc_path
    end

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
            local test_path = tree:data().path
            local envrc_path = find_envrc(test_path)

            if envrc_path then
                local envrc_vars = parse_envrc(envrc_path)
                args.env = args.env or {}
                for key, value in pairs(envrc_vars) do
                    if not args.env[key] then
                        args.env[key] = value
                    end
                end

                if next(envrc_vars) then
                    print("Loaded env vars from " .. envrc_path .. ":")
                    for key, value in pairs(envrc_vars) do
                        print("  " .. key .. "=" .. value)
                    end
                end
            end

            return args
        end,
    },
    adapters = {
        require("neotest-golang")({
            -- runner = "gotestsum",
            testify_enabled = true,
            warn_test_name_dupes = false,
            go_test_args = { "-v", "-race", "-count=1" },
            env = {
                GOARCH = "amd64"
            }
        }),
    },
})

require("coverage").setup({
    autoreload = true,
})
-- < NEOTEST
