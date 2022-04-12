return {
	"https://github.com/norcalli/nvim-colorizer.lua",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local colorizer = safe_require("colorizer")

		if not colorizer then
			return
		end

		colorizer.setup()
	end,
}
