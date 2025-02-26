-- > DEBUG
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
-- vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
dap.listeners.before.event_initialized["clear_dap_log"] = function()
    clear_dap_log()
end
-- < DEBUG
-- > DEBUGGER UI
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
    dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
end
-- < DEBUGGER UI

-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
-- > DEBUG UI
-- > GO DEBUG
dap.adapters.go = {
    type = "executable",
    command = "node",
    args = {
        require("mason-registry").get_package("go-debug-adapter"):get_install_path()
        .. "/extension/dist/debugAdapter.js",
    },
}
dap.configurations.go = {
    {
        type = "go",
        name = "Debug custom main.go path",
        request = "launch",
        showLog = true,
        program = function()
            return vim.fn.input("Path to main.go: ", vim.fn.getcwd() .. "/", "file")
        end,
        dlvToolPath = vim.fn.exepath("dlv"),
        env = {
            HOME_DIR = os.getenv("HOME"),
        },
    },
    {
        type = "go",
        name = "Debug current cwd",
        request = "launch",
        showLog = true,
        program = "${workspaceFolder}",
        dlvToolPath = vim.fn.exepath("dlv"),
        HOME_DIR = os.getenv("HOME"),
    },
}
-- < GO DEBUG
