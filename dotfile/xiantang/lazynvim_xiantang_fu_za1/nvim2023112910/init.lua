-- tmux相关
vim.keymap.set({ 'n', 't' }, '<C-h>', '<CMD>NavigatorLeft<CR>')
vim.keymap.set({ 'n', 't' }, '<C-l>', '<CMD>NavigatorRight<CR>')
vim.keymap.set({ 'n', 't' }, '<C-k>', '<CMD>NavigatorUp<CR>')
vim.keymap.set({ 'n', 't' }, '<C-j>', '<CMD>NavigatorDown<CR>')
-- 不想要这个设置
-- vim.keymap.set({'n', 't'}, '<A-p>', '<CMD>NavigatorPrevious<CR>')
--用<leader>s,水平分屏;ctrl+ws：水平分屏；ctrl+wv：垂直分屏;opts是否和local opt冲突
vim.keymap.set("n", "<Leader>v", "<C-w>v", opts)
vim.keymap.set("n", "<Leader>s", "<C-w>s", opts)
-- 打开前一个文件;打开前一个文件
vim.keymap.set("n", "<Leader>[", "<C-o>", opts)
vim.keymap.set("n", "<Leader>]", "<C-i>", opts)
-- ===================================================================
-- basic config
local set = vim.o
local opt = vim.opt
set.number = true         -- 显示行号
set.encoding = "UTF-8"    -- 支持中文
set.relativenumber = true -- 显示相对行号
-- Size of an indent
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
set.clipboard = "unnamed" -- yy复制到剪贴板

-- ===================================================================
-- 设置lazy的runtimepath
-- vim.opt['runtimepath']:prepend(vim.loop.os_homedir() .. "/home/nv01/.config/nvim/lua")
-- vim.opt['runtimepath']:prepend(vim.loop.os_homedir() .. "/home/nv01/.local/share/nvim/lazy/lazy.nvim")

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

-- ===================================================================

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
require("lazy").setup("plugins")





-- ===================================================================
-- 设置colorcheme
vim.cmd.colorscheme("base16-tender")
-- 我喜欢的背景色
vim.api.nvim_set_hl(0, "@lsp.type.variable.lua", { link = "Normal" })
vim.api.nvim_set_hl(0, "Identifier", { link = "Normal" })
vim.api.nvim_set_hl(0, "TSVariable", { link = "Normal" })

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


-- ===================================================================




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


--[[
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
--
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

cp nvim/ ~/.dotfile/lazynvim_jian_dan20231126_09 -r

/home/nv01/.local/state/nvim/swap  //删除交换文件
:verbose noremap gr	//看有哪些快捷键占用了gr
:messages   //查看错误信息
:options  //查看变量的设置

:Inspect  //支持高亮

：verbose keymap







============================================================










:help hello world!
===========================

1234 abc
456 abc
789 abc

:help hello world!
--]]
