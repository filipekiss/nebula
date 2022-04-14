return {
	"https://github.com/karb94/neoscroll.nvim",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local neoscroll = safe_require("neoscroll")
		if not neoscroll then
			return
		end

		-- BUG - Disable the nzz and Nzz mappings since they break neoscroll
		-- https://github.com/karb94/neoscroll.nvim/issues/53
		local nnoremap = safe_require("nebula.helpers.mappings").nnoremap
		nnoremap("n", "n")
		nnoremap("N", "N")

		local get_config = require("nebula.helpers.require").get_user_config
		neoscroll.setup(get_config("neoscroll"))
	end,
}
