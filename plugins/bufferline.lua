return {
	"https://github.com/akinsho/bufferline.nvim",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local bufferline = safe_require("bufferline")

		if not bufferline then
			return
		end

		local get_config = require("nebula.helpers.require").get_user_config
		bufferline.setup(get_config("bufferline"))
	end,
}
