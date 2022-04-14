local catppuccin = {
	"https://github.com/catppuccin/nvim",
	as = "catppuccin",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local catppuccin = safe_require("catppuccin")

		if not catppuccin then
			return
		end

		catppuccin.setup({
			integrations = {
				treesitter = true,
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = "italic",
						hints = "italic",
						warnings = "italic",
						information = "italic",
					},
					underlines = {
						errors = "underline",
						hints = "underline",
						warnings = "underline",
						information = "underline",
					},
				},
				lsp_trouble = true, -- enable catppuccin for trouble.nvim,
				cmp = true,
				gitsigns = true,
				telescope = true,
				which_key = true,
				indent_blankline = {
					enabled = true,
					colored_indent_levels = true,
				},
				bufferline = true,
				markdown = true,
				ts_rainbow = true,
			},
		})
	end,
}

return catppuccin
