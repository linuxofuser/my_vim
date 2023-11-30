return {
	-- 它们都是有git功能的插件
	-- 把v模式下选中的代码分享给别人；
	-- ：‘<,’>GBrowse
	{
		event = "VeryLazy",
		"tpope/vim-rhubarb"
	},
	-- 遇到冲突的解决办法
	{
		event = "VeryLazy",
		'rhysd/conflict-marker.vim',
	},
	-- 改变文档后，git会在左侧做出标记
	{
		event = "VeryLazy",
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},
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
}
