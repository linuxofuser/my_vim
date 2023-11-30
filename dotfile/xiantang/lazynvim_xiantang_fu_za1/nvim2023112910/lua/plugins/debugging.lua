return {

	-- dap install
	{
		"mfussenegger/nvim-dap",
		config=function()
-- dap setup
local dap, dapui = require("dap"), require("dapui")
--local dap = require('dap')
dap.adapters.python = function(cb, config)
	if config.request == 'attach' then
		---@diagnostic disable-next-line: undefined-field
		local port = (config.connect or config).port
		---@diagnostic disable-next-line: undefined-field
		local host = (config.connect or config).host or '127.0.0.1'
		cb({
			type = 'server',
			port = assert(port, '`connect.port` is required for a python `attach` configuration'),
			host = host,
			options = {
				source_filetype = 'python',
			},
		})
	else
		cb({
			type = 'executable',
			command = '/home/nv01/.config/nvim/python',
			args = { '-m', 'debugpy.adapter' },
			options = {
				source_filetype = 'python',
			},
		})
	end
end

local prev_function_node=nil
local prev_function_name=""

function _G.function_surrounding_cursor()
	locel ts_utils=require("nvim-treesitter.ts_utils")
	local current_node=ts_utils.get_node_at_cursor()

	if not current_node then
		return ""
	end

	local func = current_node

	while func do
		if func:type()=="class_definition" or func:type()=="class_declaration" then
			break
		end

		func= func:parent()
	end

	if not func then
		prev_class_node=nil
		prev_class_name=""
		return ""
	end

	if func == prev_function_node then
		return prev_function_name
	end

	prev_function_node=func

	local find_name
	find_name =function(node)
		for i = 0,node:named_child_count() - 1,1 do
			local child=node:named_child(i)
			local type = child:type()

			if type == "identifier" or type =="operator_name" then
				return (ts_utils.get_node_text(child))[1]
			else
				local name=find_name(child)

				if name then
					return name
				end
			end
		end

		return nil
	end

	prev_class_name=find_name(func)
	return prev_class_name
end

dap.Set_log_leveL=("TRACE")

local function get_module_path()
	return vim.fn.expand("%:.:r:gs?/?.?")
end

local function prune_nil(items)
	return vim.tbl_filter(function(x)
		return x
	end,items)
end

local function log_to_file()


	vim.env.DEBUGPY_LOG_DIR=vim.fn.stdpath("cache") .. "/debugpy"
	return true
end

-- dap config
dap.configurations.python = {
	{
		type = 'python',
		request = 'launch',
		name = "Launch file",
		program = "${file}",
		pythonPath = function()
			return '/home/nv01/.virtualenvs/debugpy/bin/python3.11'
		end,
	},
	{
		type ="python",
		request="attach",
		name ="Attach remote",
		connect=function()
			local host =vim.fn.input("Host [127.0.0.1]: ")
			host=host~="" and host or "127.0.0.1"
			local port=tonumber(vim.fn.input("Port  [5678]: ")) or 5678
				return {host=host,port=port}
			end,
	}，
	{
	type ="python",
	request ="aunch",
	name = "Debug test function",
	module ="unittest",
	args=function()
		local path=get_module_path()
		local classname = class_surrounding_cursor()
		local function_name = function_surrounding_cursor()
		local test_path = table.concat(prune_nil({ path, classname, function_name}) ".")
		return {
				"-v",
				test_path,
			}
end,
console="integratedTerminal",
justMyCode =false,
logToFile =log_to_file,
pythonPath = function()
	return "/usr/bin/python"
end,
	},


require("dapui").setup()
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

vim.keymap.set("n", "<leader>dr", function()
	require("dap").continue()
end)

vim.keymap.set("n", "<leader>de", function()
	require("dap").toggle_breakpoint()
end)

vim.keymap.set("n", "<leader>dn", function()
	require("dap").step_over()
end)

vim.keymap.set("n", "<leader>di", function()
	require("dap").step_into()
end)

vim.keymap.set("n", "<leader>do", function()
	require("dap").step_out()
end)

vim.keymap.set("n", "<leader>dc", function()
	require("dap").disconnect()
end)
end,
},
	-- dap-ui install
	{
		"rcarriga/nvim-dap-ui",
	},
}
