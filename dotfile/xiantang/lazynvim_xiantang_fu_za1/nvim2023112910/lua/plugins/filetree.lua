return {
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
			"Xuyuanp/nerdtree-git-plugin", -- 能看到文档做了哪些修改
			"ryanoasis/vim-devicons", -- 文件前面有一个图标
		}
	},
}
