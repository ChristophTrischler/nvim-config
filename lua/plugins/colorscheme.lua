return {
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = false, 
		priority = 1000,
		opts = function()
			return {
				transparent = true, -- Enable this to disable setting the background color
				terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
				styles = {
					comments = { italic = true },
					keywords = { italic = true },
					functions = {},
					variables = {},
					sidebars = "dark",
					floats = "dark",
				},

				---@param highlights Highlights
				---@param colors ColorScheme
				on_highlights = function(highlights, colors)
					highlights.LspInlayHint = {
						bg = colors.none,
						fg = colors.base01,
					}
					highlights.NeoTreeNormal = {
						bg = colors.none,
					}
					highlights.NeoTreeNormalNC = {
						bg = colors.none,
					}
				end,
			}
		end,
	},
}
