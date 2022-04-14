return {
	"https://github.com/lukas-reineke/indent-blankline.nvim",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local indentline = safe_require("indent_blankline")

		if not indentline then
			return
		end

		local get_user_config =
			require("nebula.helpers.require").get_user_config
		indentline.setup(get_user_config("indent-line"))
	end,
}
