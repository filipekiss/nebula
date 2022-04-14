return {
	"https://github.com/folke/which-key.nvim",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local whichkey = safe_require("which-key")

		if not whichkey then
			return
		end

		local get_config = require("nebula.helpers.require").get_user_config
		whichkey.setup(get_config("which-key"))
	end,
}
