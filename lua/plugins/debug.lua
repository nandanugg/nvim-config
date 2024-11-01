-- TODO: plugins to try
-- https://github.com/nvim-neotest/neotest
--
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
			size = 50,
			position = "right",
		},
	},
})
require("nvim-dap-virtual-text").setup({
	commented = true,
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
-- > PHP DEBUG
dap.adapters.php = {
	type = "executable",
	command = "node",
	args = {
		require("mason-registry").get_package("php-debug-adapter"):get_install_path() .. "/extension/out/phpDebug.js",
	},
}
dap.configurations.php = {
	{
		type = "php",
		request = "launch",
		name = "Debug PHPUnit Method",
		program = function()
			local file_path = vim.fn.expand("%:p")
			return file_path
		end,
		args = function()
			local aerial = require("aerial")
			local function_name = ""

			-- Try to get the current symbol (function name) from aerial
			local symbol = aerial.get_location()
			if symbol and symbol.kind == "Function" then
				function_name = symbol.name
			end

			-- Fallback to input if function name is not detected
			function_name = vim.fn.input("Method to test (leave blank to test all): ", function_name)

			if function_name == "" then
				return {} -- No filter, run all tests
			else
				return { "--filter", function_name }
			end
		end,
		cwd = "${workspaceFolder}",
		port = 9003,
		runtimeExecutable = "php",
		runtimeArgs = { "${workspaceFolder}/backend/vendor/bin/phpunit" },
		stopOnEntry = false,
		log = true,
		exceptionBreakpoints = { "All" },
	},
	{
		type = "php",
		request = "launch",
		name = "Debug kenaikanJabatan:TTEManual",
		args = function()
			local arg = vim.fn.input("list nidn: ")
			return { "kenaikanJabatan:TTEManual", "LK", arg }
		end,
		program = "${workspaceFolder}/backend/artisan",
		cwd = "${workspaceFolder}/backend",
		port = 9003,
		runtimeExecutable = "php",
		log = true,
		stopOnEntry = false,
		exceptionBreakpoints = { "All" },
	},
	{
		type = "php",
		request = "launch",
		name = "Debug kenaikanJabatan:insert",
		args = function()
			local arg1 = vim.fn.input("id_periode_kegiatan: ")
			local arg2 = vim.fn.input("id_pengguna: ")
			local arg3 = vim.fn.input("list nidn: ")
			return { "kenaikanJabatan:insert", arg1, arg2, arg3 }
		end,
		program = "${workspaceFolder}/backend/artisan",
		cwd = "${workspaceFolder}/backend",
		port = 9003,
		runtimeExecutable = "php",
		log = true,
		stopOnEntry = false,
		exceptionBreakpoints = { "All" },
	},
	{

		type = "php",
		request = "launch",
		name = "Listen for Xdebug",
		port = 9003,
		exceptionBreakpoints = { "All" },
	},
}
-- < PHP DEBUG
-- > GO DEBUG
-- dap.adapters.go = {
-- 	type = "executable",
-- 	command = "node",
-- 	args = {
-- 		require("mason-registry").get_package("go-debug-adapter"):get_install_path()
-- 			.. "/extension/dist/debugAdapter.js",
-- 	},
-- }
-- dap.configurations.go = {
-- 	{
-- 		type = "go",
-- 		name = "Debug custom main.go path",
-- 		request = "launch",
-- 		showLog = false,
-- 		program = function()
-- 			-- Prompt the user to enter the path to the program to debug
-- 			return vim.fn.input("Path to main.go: ", vim.fn.getcwd() .. "/", "file")
-- 		end,
-- 		dlvToolPath = vim.fn.exepath("dlv"), -- Automatically locate Delve
-- 	},
-- 	{
-- 		type = "go",
-- 		name = "Debug current cwd",
-- 		request = "launch",
-- 		showLog = false,
-- 		program = "${workspaceFolder}",
-- 		dlvToolPath = vim.fn.exepath("dlv"),
-- 	},
-- }
-- < GO DEBUG
require("neotest").setup({
	log_level = vim.log.levels.DEBUG,
	adapters = {
		require("neotest-phpunit")({
			phpunit_cmd = function()
				local currentCwd = vim.fn.getcwd()
				return currentCwd .. "/backend/vendor/bin/phpunit"
			end,
			root_files = { "composer.json", "phpunit.xml" },
			env = {
				XDEBUG_CONFIG = "idekey=neotest",
			},
			dap = { -- this is for neotest
				log = true,
				type = "php",
				request = "launch",
				name = "Listen for XDebug from neotest",
				port = 9003,
				cwd = "${workspaceFolder}/backend",
				runtimeExecutable = "php",
				stopOnEntry = false,
				breakpoints = {
					exception = {
						Notice = false,
						Warning = false,
						Error = false,
						Exception = false,
						["*"] = false,
					},
				},
			},
		}),
	},
})
