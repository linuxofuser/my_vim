return {
	-- 让neovim记住你上次保存的位置；
	-- persistence  持久化
	{
		"folke/persistence.nvim",
		event = "BufReadPre", -- this will only start session saving when an actual file was opened
		config = function()
			require("persistence").setup()
		end,
	},
}
