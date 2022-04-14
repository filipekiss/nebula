return {
	"kyazdani42/nvim-web-devicons",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local icons = safe_require("nvim-web-devicons")

		if not icons then
			return
		end

		icons.setup()
	end,
}
