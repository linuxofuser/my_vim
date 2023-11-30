return {
	-- find files;它有很多功能，如跳转，打开并操作浏览器，以后再学习
	-- dnf install ripgrep
	-- :Telescope  可以看到它有列表列出来，说明它已经正常工作了;还不懂它的用法
	-- :Telescope find_files
	{
		-- 当第一次启动nvim时，它并不加载，https://github.com/folke/lazy.nvim  //很多nvim特性都可以在这里找到，如cmd,keys等；
		cmd = "Telescope", -- 只有输入:Telescope，它才启动;-- 命令行加载
		keys = {     -- 只有输入keybinding(:Telescope)，它才启动;-- 快捷键加载
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
}
