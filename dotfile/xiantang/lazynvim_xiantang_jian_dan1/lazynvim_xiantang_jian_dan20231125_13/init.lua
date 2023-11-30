local set = vim.o
local opt = vim.opt
set.number = true         -- 显示行号
set.encoding = "UTF-8"    -- 支持中文
set.relativenumber = true -- 显示相对行号
-- Size of an indent
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
set.clipboard = "unnamed" -- yy复制到剪贴板

-- ===================================================================
-- 设置lazy的runtimepath
vim.opt['runtimepath']:prepend(vim.loop.os_homedir() .. "/home/nv01/.config/nvim/lua")
vim.opt['runtimepath']:prepend(vim.loop.os_homedir() .. "/home/nv01/.local/share/nvim/lazy/lazy.nvim")

-- ===================================================================
-- 在拷贝后高亮
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	pattern = { "*" },
	callback = function()
		vim.highlight.on_yank({
			timeout = 300,
		})
	end,
})

-- ===================================================================
-- keybindings
local opts = { noremap = true, silent = true }
vim.g.mapleader = " "
-- vim.keymap.set("n", "<C-l>", "<C-w>l", opts) -- 在各个窗口中移动，ctrl+l:向右移动
-- vim.keymap.set("n", "<C-h>", "<C-w>h", opts) --opt -- 和下面的配置有冲突,关掉
-- vim.keymap.set("n", "<C-j>", "<C-w>j", opts) --opt
-- vim.keymap.set("n", "<C-k>", "<C-w>k", opts) --opt
-- ctrl+hl  //调整窗口的大小
vim.keymap.set({ 'n', 't' }, '<C-h>', '<CMD>NavigatorLeft<CR>')
vim.keymap.set({ 'n', 't' }, '<C-l>', '<CMD>NavigatorRight<CR>')
vim.keymap.set({ 'n', 't' }, '<C-k>', '<CMD>NavigatorUp<CR>')
vim.keymap.set({ 'n', 't' }, '<C-j>', '<CMD>NavigatorDown<CR>')
-- vim.keymap.set({'n', 't'}, '<A-p>', '<CMD>NavigatorPrevious<CR>') -- 不想这个设置

-- ===================================================================
--用<leader>s,水平分屏;ctrl+ws：水平分屏；ctrl+wv：垂直分屏
vim.keymap.set("n", "<Leader>v", "<C-w>v", opts)
vim.keymap.set("n", "<Leader>s", "<C-w>s", opts)

-- ===================================================================
-- 打开前一个文件;打开前一个文件
vim.keymap.set("n", "<Leader>[", "<C-o>", opts)
vim.keymap.set("n", "<Leader>]", "<C-i>", opts)

-- ===================================================================
-- 如果一行折为两行，会跳到第一行
vim.keymap.set("n", "j", [[v:count ? 'j' : 'gj']], { noremap = true, expr = true })
vim.keymap.set("n", "k", [[v:count ? 'k' : 'gk']], { noremap = true, expr = true })

-- ===================================================================
-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"branch=stable", -- latest stable release
		lazypath,
	})
end

-- ===================================================================
-- lazy of require
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({

	-- ===================================================================
	-- 把v模式下选中的代码分享给别人；
	-- ：‘<,’>GBrowse
	{
		event = "VeryLazy",
		"tpope/vim-rhubarb"
	},
	-- ===================================================================
	-- 遇到冲突的解决办法
	{
		"numToStr/Navigator.nvim",
		config = function()
			require("Navigator").setup()
		end,
	},
	-- ===================================================================
	-- dap install
	{
		"mfussenegger/nvim-dap",
	},
	-- ===================================================================
	-- dap-ui install
	{
		"rcarriga/nvim-dap-ui",
	},
	-- ===================================================================
	-- 遇到冲突的解决办法
	{
		event = "VeryLazy",
		'rhysd/conflict-marker.vim',
	},
	-- ===================================================================
	-- persistence
	{
		"folke/persistence.nvim",
		event = "BufReadPre", -- this will only start session saving when an actual file was opened
		config = function()
			require("persistence").setup()
		end,
	},
	-- ===================================================================
	-- colorscheme
	{
		"RRethy/nvim-base16",
		lazy = true,
	},
	-- ===================================================================
	-- nerdtree; :NERDTree  -- <leader>t/t //打开关闭nerdtree NERDTreeFind  //找到这个文件的存放的路径  //ma[/]  //增加一个文件或文件夹  mm  //给一个文件改名  m是调出功能列表，其他的可以看着来；
	{

		keys = {
			{ "<leader>t", ":NERDTreeToggle<CR>", desc = "toggle nerdtree" },
			{ "<leader>l", ":NERDTreeFind",       desc = "nerdtree find" },
		},
		cmd = { "NERDTreeToggle", "NERDTree", "NERDTreeFind" },
		"preservim/nerdtree",
		config = function()
			vim.cmd([[
" enable Line numbers
let NERDTreeShowLineNumbers=1
" make sure relative line numbers are used
autocmd FileType nerdtree setlocal relativenumber
]])
		end,
		dependencies = {
			'Xuyuanp/nerdtree-git-plugin', -- 能看到文档做了哪些修改
			'ryanoasis/vim-devicons',   -- 文件前面有一个图标

		}
	},
	-- ===================================================================
	-- nvim-treesitter-textobjects
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		config = function()
			require 'nvim-treesitter.configs'.setup {
				textobjects = {
					swap = { -- <leader>a  //实现两个参数交换
						enable = true,
						swap_next = {
							["<leader>a"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>A"] = "@parameter.inner",
						},
					},
					select = {
						enable = true,

						-- Automatically jump forward to textobj, similar to targets.vim
						lookahead = true,

						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["af"] = "@function.outer", -- vaf
							["if"] = "@function.inner", -- vif
							["aa"] = "@parameter.outer", -- vaa
							["ia"] = "@parameter.inner", -- via
							["ac"] = "@class.outer",
							-- You can optionally set descriptions to the mappings (used in the desc parameter of
							-- nvim_buf_set_keymap) which plugins like which-key display
							["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
							-- You can also use captures from other query groups like `locals.scm`
							["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
						},
						-- You can choose the select mode (default is charwise 'v')
						--
						-- Can also be a function which gets passed a table with the keys
						-- * query_string: eg '@function.inner'
						-- * method: eg 'v' or 'o'
						-- and should return the mode ('v', 'V', or '<c-v>') or a table
						-- mapping query_strings to modes.
						selection_modes = {
							['@parameter.outer'] = 'v', -- charwise
							['@function.outer'] = 'V', -- linewise
							['@class.outer'] = '<c-v>', -- blockwise
						},
						-- If you set this to `true` (default is `false`) then any textobject is
						-- extended to include preceding or succeeding whitespace. Succeeding
						-- whitespace has priority in order to act similarly to eg the built-in
						-- `ap`.
						--
						-- Can also be a function which gets passed a table with the keys
						-- * query_string: eg '@function.inner'
						-- * selection_mode: eg 'v'
						-- and should return true of false
						include_surrounding_whitespace = true,
					},
				},
			}
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- 它依赖于nvim-treesitter
		},
	},
	-- ===================================================================
	-- treesitter
	-- :TSInstall lua vim
	--
	{
		"nvim-treesitter/nvim-treesitter", --  //可以解析语法，做很多事情
		config = function()
			require("nvim-treesitter.configs").setup({
				incremental_selection = { -- 增量选择
					enable = true,
					keymaps = {
						node_incremental = "v", -- 按照node的方式去选，把光标定位到你要选择的地方，按*v，它能智能的选择块，如果选择错了，再按退格键，能回到你上一次选择的状态，比较杀手级的功能
						node_decremental = "<BS>", -- <BS>就是退格键
					},
				},
				highlight = {
					enable = true,
				},
			})
		end,
	},
	-- ===================================================================
	-- 补全的时候给你一个文档;
	{
		"folke/neodev.nvim"
	},
	-- ===================================================================
	-- 让neovim记住你上次保存的位置；安装了，没有配置，暂时没有效果
	{
		"folke/persistence.nvim"
	},
	-- ===================================================================
	-- find files;它有很多功能，如跳转，打开并操作浏览器，以后再学习
	-- dnf install ripgrep
	-- :Telescope  可以看到它有列表列出来，说明它已经正常工作了;还不懂它的用法
	-- :Telescope find_files
	{
		-- 当第一次启动nvim时，它并不加载，https://github.com/folke/lazy.nvim  //很多nvim特性都可以在这里找到，如cmd,keys等；
		cmd = "Telescope", -- 只有输入:Telescope，它才启动;-- 命令行加载
		keys = {         -- 只有输入keybinding(:Telescope)，它才启动;-- 快捷键加载
			{ "<leader>p",  ":Telescope find_files<CR>", desc = "find files" },
			{ "<leader>P",  ":Telescope live_grep<CR>",  desc = "grep files" },
			{ "<leader>rs", ":Telescope resume<CR>",     desc = "resume" },
			{ "<leader>q",  ":Telescope oldfiles<CR>",   desc = "oldfiles" },
			-- :Telescope find_files
			-- :Telescope live_grep
			-- :Telescope resume
			-- :Telescope oldfiles
		},
		'nvim-telescope/telescope.nvim',
		tag = '0.1.4',
		-- or        branch =  '0.1.1',--#:Telescope	:Telescope find_files	:Lazy  //可以看到它是否随nvim启动
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	-- ===================================================================
	-- code completion
	{
		event = "VeryLazy",
		"hrsh7th/nvim-cmp",
		dependencies = {
			'neovim/nvim-lspconfig',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
			'hrsh7th/nvim-cmp',
			'L3MON4D3/LuaSnip',
		}
	},
	-- ===================================================================
	-- 改变文档后，git会在左侧做出标记
	{
		event = "VeryLazy",
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},
	-- ===================================================================
	-- 自动匹配括号;输入函数后补全括号
	{
		event = "VeryLazy",
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup()
		end,
	},
	-- ===================================================================
	-- install git
	{
		event = "VeryLazy",
		"tpope/vim-fugitive",
		cmd = "Git",
		config = function()
			-- convert 输入一个错误的单词git，它会把正确的单词Git输上，我们要的是Git；
			vim.cmd.cnoreabbrev([[git Git]])
			vim.cmd.cnoreabbrev([[gp Git push]]) -- :pu/Pu  //会放到上一行，下一行
		end,
	},
	-- ===================================================================
	-- nvim-lspconfig mason-lspconfig
	{
		event = "VeryLazy",
		"neovim/nvim-lspconfig",
		dependencies = { 'williamboman/mason-lspconfig.nvim' }
	},
	-- ===================================================================
	-- null-ls.nvim,null-ls没有工作
	{
		event = "VeryLazy",
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.black,
				},
				-- you can reuse a shared lspconfig on_attach callback here
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
								-- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
								--vim.lsp.buf.format({ bufnr = bufnr })
								--vim.lsp.buf.formatting_sync()
								vim.lsp.buf.format({ async = false })
							end,
						})
					end
				end,
			})
		end,
	},
	-- ===================================================================
	-- mason
	{
		event = "VeryLazy",
		"williamboman/mason.nvim",
		build = ":MasonUpdate", -- no tag

		--config = function()  -- config;后面有配置
		--	require("mason").setup()
		--end,
	},
	-- ===================================================================




})





-- ===================================================================
-- 设置colorcheme
vim.cmd.colorscheme("base16-tender")

-- ===================================================================
-- ===================================================================
--Telescope 先不设置，因为设置了，它会随nvim一起启动，我想要它懒加载
--local builtin = require('telescope.builtin')
--vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
--vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
--vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
--vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- ===================================================================
-- Global mappings. -- on_atton  --keybindings
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
		vim.keymap.set('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set('n', '<Leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set('n', '<Leader>wl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, opts)
		vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, opts)
		vim.keymap.set({ 'n', 'v' }, '<Leader>ca', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
		vim.keymap.set('n', '<Leader>f', function()
			vim.lsp.buf.format { async = true }
		end, opts)
	end,
})

-- ===================================================================
-- lspconfig config
local lspconfig = require('lspconfig')

-- ===================================================================
-- mason masonlspconfig config
require("mason").setup()
require("mason-lspconfig").setup()

-- ===================================================================
-- Set up lspconfig.要设置在lspconfig之前的地方.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- ===================================================================
-- neodev config
-- 放在lua_ls之前;很酷
require("neodev").setup({
	-- add any options here, or leave empty to use the default settings
})

-- ===================================================================
--("lspconfig")
require("lspconfig").lua_ls.setup({
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim", "hs" },
			},
			workspace = {
				checkThirdParty = false,
				-- Make the server aware of Neovim runtime files
				library = {
					-- vim.api.nvim_get_runtime_file("", true),
					"/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/",
					vim.fn.expand("~/lualib/share/lua/5.4"),
					vim.fn.expand("~/lualib/lib/luarocks/rocks-5.4"),
					"/opt/homebrew/opt/openresty/lualib",
				},
			},
			completion = {
				callSnippet = "Replace",
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})

-- ===================================================================
-- pyright config
-- python completion
require 'lspconfig'.pyright.setup {
	capabilities = capabilities
}


-- ===================================================================
-- nvim cmp
-- Set up nvim-cmp.

local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")
local cmp = require("cmp")
-- autopairs config
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			-- vim.fn["vsnip#anonymous"](args.body)  -- For `vsnip` users.
			require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
			-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
			-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		-- Super-Tab like mapping
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
				-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
				-- that way you will only jump inside the snippet region
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-c>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		-- { name = 'vsnip' },   -- For vsnip users.
		{ name = 'luasnip' }, -- For luasnip users.
		-- { name = 'ultisnips' }, -- For ultisnips users.
		-- { name = 'snippy' }, -- For snippy users.
	}, {
		{ name = 'buffer' },
	})
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
	}, {
		{ name = 'buffer' },
	})
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})

------------------------------------
---- 拿到它的启动函数
--persistence on start
--:lua print(vim.api.nvim_get_vvar("argv"))
--:lua print(vim.inspect(vim.api.nvim_get_vvar("argv")))
-- 裸开nvim直接打开默认的文件
local args = vim.api.nvim_get_vvar("argv")
-- embed
if #args > 2 then
else
	require("persistence").load({ last = true })
end

-------------------------
vim.cmd([[
" disable the default highlight group
let g:conflict_marker_highlight_group = ''

" Include text after begin and end markers
let g:conflict_marker_begin = '^<<<<<<< .*$'
let g:conflict_marker_end   = '^>>>>>>> .*$'

highlight ConflictMarkerBegin guibg=#2f7366
highlight ConflictMarkerOurs guibg=#2e5049
highlight ConflictMarkerTheirs guibg=#344f69
highlight ConflictMarkerEnd guibg=#2f628e
highlight ConflictMarkerCommonAncestorsHunk guibg=#754a81
]])

-- 我喜欢的背景色
vim.api.nvim_set_hl(0, "@lsp.type.variable.lua", { link = "Normal" })
vim.api.nvim_set_hl(0, "Identifier", { link = "Normal" })
vim.api.nvim_set_hl(0, "TSVariable", { link = "Normal" })

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
			command = '/home/nv01/.virtualenvs/debugpy/bin/python3.11',
			args = { '-m', 'debugpy.adapter' },
			options = {
				source_filetype = 'python',
			},
		})
	end
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
}


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
-- dap keymap2
-- show the debug console
dap.defaults.fallback.console = "internalConsole"

dap.listeners.after["event_initialized"]["key_map"] = function()
	-- close nerd tree
	vim.cmd("NERDTreeClose")
	require("dapui").open()
	vim.api.nvim_set_keymap("n", "c", '<cmd>lua require"dap".continue()<CR>', { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "n", '<cmd>lua require"dap".step_over()<CR> | zz', { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "s", '<cmd>lua require"dap".step_into()<CR> | zz', { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "o", '<cmd>lua require"dap".step_out()<CR> | zz', { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "r", '<cmd>lua require"dap".repl.open()<CR>', { noremap = true, silent = true })
	-- stop terminal
	vim.api.nvim_set_keymap("n", "q", '<cmd>lua require"dap".disconnect()<CR>', { noremap = true, silent = true })
end
--[[
function defer()
	require("dapui").close()
	vim.cmd("NERDTreeToggle | wincmd p")
	 -- rollback to default keymap
	-- nvim_del_keymap
	-- source keymap.lua
	vim.cmd("source ~/.config/nvim/lua/keymap.lua")
end
dap.listeners.after["disconnected"]["key_map"] = function()
	defer()
end
--]]











--[[
NB人物：folke    williamboman
这里写说明性的文档

痛点
folke/persistence.nvim  //下次进入neovim的时候，保留上次的状态
which-key  //帮你记住很多快捷键；可以在网上搜索一些keybinding reddit
which-key.nvim  //keybinding(keymap)太多了，记不住，可以用这个；
fuzzy  //搜索文件，单词
finder  //搜索文件，单词
'nvim-telescope/telescope.nvim'  //搜索文件，单词；已安装；
lsp  //是一个语言服务协议，是微软的一个很好的方案；
mason  //管理lsp的一个管理器；"williamboman/mason.nvim"；williamboman 很出名；
lspconfig  //它已经进到core里面了;"neovim/nvim-lspconfig"
mason-lspconfig  //"williamboman/mason-lspconfig.nvim";它把lsp和lspconfig做了融和；
nvim-cmp  //是一个补全的插件；"hrsh7th/nvim-cmp";比较应用，应用没有coc好，但也不弱；
code completion  //代码补全
search completion  //查找补全
cmd completion  //命令行补全
go to definition  //跳转
find references  //代码块之间跳转
code formating  //代码格式化
null-ls.nvim  //
event = "VeryLazy", -- 当nvim启动后，才马上加载mason,让nvim启动更快一点，如果配不成懒加载，就配成VeryLazy
vim keybinds reddit  //vim中绑定的快捷键，可以在网页中查找；https://i.imgur.com/YLInLY.png
:pu  //在光标所在行的下一行插入
:'<,'>s/.*'\(.*\)'/ "<leader>q",  "\1<CR>",   desc = "oldfiles" }, //格式化一段代码
：Lazy update mason  //升级mason
:MasonInstall pyright  //安装pyright
:MasonInstall lua-language-server  //安装lua
:Lazy update nvim-lspconfig
:LspInfo //能看到lua已经加载进来了
:lua vim.lsp.buf.format()  //已经可以用了
:Inspect  //还不懂
:%s/space/Leader/gc  //把space换成Leader，但是要经过我的确认
vim substitution one by one  //vim一个一个的确认
v6j  //进入可视模式，向下选择6行
:'<,'>s/.*\('.*'\)/\t\1 //:'<,'>  //你选择的文本;  s  //字符替换;  /.*  //待处理的文本;  \('.*'\)  //匹上配的文本;  /\t  //插入一个制表符;\1  //显示匹配上的文本；\2:是你不需要的文本;
:Lazy install lazy.nvim
nvim /home/nv01/.config/nvim/lazy-lock.json	//如果你更新错了，可以回滚回来
:Lazy update	//error
:Lazy restore	//如果你更新错了，可以回滚回来
:Lazy install nvim-base16
:pu!  //回车后把剪切板的内容拷贝到这行的上面
git操作
    Git
    按=，可以看到diff;
    放在M上，按s,把它加入到staged;
    按cc,进行commit;
    进入插入模式：
    add git support
    :q
    最后，我们按：git push;可能 按键不一样，：Git push;
不要覆盖默认的快捷键
==================================
operator+textobj
c,d,v,y
:help OPERATOR
de  //删除下一个单词，从光标处向后删除
dge  /v/删除光标到上一个单词倒数第二个字母
ce

:help text-objects
aw  //vaw  光标处单词及后面的一个空格
iw
aW  //W  会把特殊字符也选上
iW
p  //段落;vip  vap会把段落下面的很多空格也选上
text-object = i/a + w/p/[{('<"`
ci" //不能跨行操作
ci( //能跨行操作



---------------
ctrl+v;I;ssh ;esc;ctrl+v;A; sudo docker xxx
;esc;    ctrl+v,jjkk;e;$;A; sudo docker;esc
e/$/gv  //重新再选择上次的v模式
ssh 123 sudo docker xxx
ssh 456 sudo docker xxx
ssh 789 sudo docker xxx
-------------
:/\<open\>  //精确搜索open单词
:help :global
:g/^$/d  //删除文档中所有的空行
:g/[\t| ]-- /d  //删除制表符，空格，-- 开关的行
:qaq:g/gattern/y A  //qaq:清除a寄存器；把你搜索的单词拷到寄存器A；
:[range]s[ubstitute]/{pattern}/{string}/[flags] [count]
:%s/open/close/gc  //%:竖向寻找，g：整行寻找;c:one by one替换
同时在一个块的前面和后面加缀
ctrl+v; : ;
:'<,'>s/\(.*\)ssh \1 sudo docker restart xxx  //\1:fefernece
=========================================================
adp  //微软的调试通用协议接口;apapter;
Python
Install debugpy into a virtualenv
----------------------
mkdir .virtualenvs
cd .virtualenvs
python -m venv debugpy
debugpy/bin/python -m pip install debugpy
----------------------
For example:

>lua
    local dap = require('dap')
    dap.configurations.python = {
      {
        type = 'python';
        request = 'launch';
        name = "Launch file";
        program = "${file}";
        pythonPath = function()
          return '/usr/bin/python'
        end;
      },
    }
------------------------------
Usage
A typical debug flow consists of:

Setting breakpoints via :lua require'dap'.toggle_breakpoint().-- 打断点
Launching debug sessions and resuming execution via :lua require'dap'.continue().
Stepping through code via :lua require'dap'.step_over() and :lua require'dap'.step_into().
Inspecting the state via the built-in REPL: :lua require'dap'.repl.open() or using the widget UI (:help dap-widgets)
-------------------------------
[nv01@fedora .config]$ which python
/usr/bin/python
-----------------------------------
To get started simply call the setup method on startup, optionally providing custom settings.

require("dapui").setup()
You can open, close and toggle the windows with corresponding functions:

require("dapui").open()
require("dapui").close()
require("dapui").toggle()
-------------------------------------------














============================================================










:help hello world!
===========================

1234 abc
456 abc
789 abc

:help hello world!
--]]
