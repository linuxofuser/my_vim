return {
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
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		config = function()
			require("nvim-treesitter.configs").setup({
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
			})
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- 它依赖于nvim-treesitter
		},
	}
}
