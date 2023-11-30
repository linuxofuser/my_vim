return {
	{
		-- 快速定位你想要的单词
		'jinh0/eyeliner.nvim',
		config = function()
			require 'eyeliner'.setup {
				highlight_on_key = true, -- show highlights only after keypress
				dim = false  -- dim all other characters if set to true (recommended!)
			}
		end,
	},
	{
		"romainl/vim-cool",
	},
	{
		"vim-scripts/ReplaceWithRegister",
	},
	{
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end,
},
}
