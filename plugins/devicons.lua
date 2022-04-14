return {
	"kyazdani42/nvim-web-devicons",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local icons = safe_require("nvim-web-devicons")

		if not icons then
			return
		end

		local get_config = require("nebula.helpers.require").get_user_config
		icons.setup(get_config("devicons"))
	end,
}
