local set = vim.o
local opt = vim.opt
set.number = true
set.relativenumber = true
opt.shiftwidth = 2        -- Size of an indent
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
vim.keymap.set("n", "<C-l>", "<C-w>l", opts) -- 在各个窗口中移动，ctrl+l:向右移动
vim.keymap.set("n", "<C-h>", "<C-w>h", opts) --opt
vim.keymap.set("n", "<C-j>", "<C-w>j", opts) --opt
vim.keymap.set("n", "<C-k>", "<C-w>k", opts) --opt

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
	-- colorscheme
	{
		"RRethy/nvim-base16",
		lazy = true,
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
	-- 自动匹配括号;输入函数后补全括号
	{
		event = "VeryLazy",
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup()
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


--[[
-- :Lazy install lazy.nvim
-- nvim /home/nv01/.config/nvim/lazy-lock.json	//如果你更新错了，可以回滚回来
-- :Lazy update	//error
-- :Lazy restore	//如果你更新错了，可以回滚回来
-- :Lazy install nvim-base16
--
--
--]]




-- ===================================================================
-- 设置colorcheme
vim.cmd.colorscheme("base16-tender")

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
































--[[
-- NB人物：folke    williamboman
-- 这里写说明性的文档
--
-- 痛点
-- folke/persistence.nvim  //下次进入neovim的时候，保留上次的状态
-- which-key  //帮你记住很多快捷键；可以在网上搜索一些keybinding reddit
-- which-key.nvim  //keybinding(keymap)太多了，记不住，可以用这个；
-- fuzzy  //搜索文件，单词
-- finder  //搜索文件，单词
-- 'nvim-telescope/telescope.nvim'  //搜索文件，单词；已安装；
-- lsp  //是一个语言服务协议，是微软的一个很好的方案；
-- mason  //管理lsp的一个管理器；"williamboman/mason.nvim"；williamboman 很出名；
-- lspconfig  //它已经进到core里面了;"neovim/nvim-lspconfig"
-- mason-lspconfig  //"williamboman/mason-lspconfig.nvim";它把lsp和lspconfig做了融和；
-- nvim-cmp  //是一个补全的插件；"hrsh7th/nvim-cmp";比较应用，应用没有coc好，但也不弱；
-- code completion  //代码补全
-- search completion  //查找补全
-- cmd completion  //命令行补全
-- go to definition  //跳转
-- find references  //代码块之间跳转
-- code formating  //代码格式化
-- null-ls.nvim  //
-- event = "VeryLazy", -- 当nvim启动后，才马上加载mason,让nvim启动更快一点，如果配不成懒加载，就配成VeryLazy
-- vim keybinds reddit  //vim中绑定的快捷键，可以在网页中查找；https://i.imgur.com/YLInLY.png
-- :pu  //在光标所在行的下一行插入
-- :'<,'>s/.*'\(.*\)'/ "<leader>q",  "\1<CR>",   desc = "oldfiles" }, //格式化一段代码
-- ：Lazy update mason  //升级mason
-- :MasonInstall pyright  //安装pyright
-- :MasonInstall lua-language-server  //安装lua
-- :Lazy update nvim-lspconfig
-- :LspInfo //能看到lua已经加载进来了
-- :lua vim.lsp.buf.format()  //已经可以用了
-- :Inspect  //还不懂
-- :%s/space/Leader/gc  //把space换成Leader，但是要经过我的确认
-- vim substitution one by one  //vim一个一个的确认
-- v6j  //进入可视模式，向下选择6行
-- :'<,'>s/.*\('.*'\)/\t\1 //:'<,'>  //你选择的文本;  s  //字符替换;  /.*  //待处理的文本;  \('.*'\)  //匹上配的文本;  /\t  //插入一个制表符;\1  //显示匹配上的文本；\2:是你不需要的文本;
--
--
--
--
--
--
--]]
