return {
	"https://github.com/akinsho/bufferline.nvim",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local bufferline = safe_require("bufferline")

		if not bufferline then
			return
		end

		bufferline.setup()
	end,
}
