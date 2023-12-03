vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true



return {
	"nvim-neo-tree/neo-tree.nvim",
	lazy = false,
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require('neo-tree').setup {
			close_if_last_window = true,
			window = {
				mappings = {
				}
			}
		}
	end,
}
