return {
	"https://github.com/nvim-lualine/lualine.nvim",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local lualine = safe_require("lualine")

		if not lualine then
			return
		end

		lualine.setup({
			options = {
				theme = "catppuccin",
			},
		})
	end,
}
