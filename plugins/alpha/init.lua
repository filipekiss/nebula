return {
	"https://github.com/goolord/alpha-nvim",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local get_config = require("nebula.helpers.require").get_config
		local alpha = safe_require("alpha")

		if not alpha then
			return
		end

		alpha.setup(get_config("plugins.alpha.dashboard"))
	end,
}
