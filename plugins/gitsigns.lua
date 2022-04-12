return {
	"https://github.com/lewis6991/gitsigns.nvim",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local gitsigns = safe_require("gitsigns")

		if not gitsigns then
			return
		end

		gitsigns.setup()
	end,
}
