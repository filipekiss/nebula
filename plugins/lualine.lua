return {
	"https://github.com/nvim-lualine/lualine.nvim",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local lualine = safe_require("lualine")

		if not lualine then
			return
		end

		local get_config = require("nebula.helpers.require").get_user_config
		lualine.setup(get_config("lualine"))
	end,
}
