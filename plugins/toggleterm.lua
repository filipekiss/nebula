return {
	"https://github.com/akinsho/toggleterm.nvim",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local toggleterm = safe_require("toggleterm")

		if not toggleterm then
			return
		end

		local get_config = require("nebula.helpers.require").get_user_config
		toggleterm.setup(get_config("toggleterm"))
	end,
}
