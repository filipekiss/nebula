return {
	"https://github.com/nvim-treesitter/nvim-treesitter",
	run = ":TSUpdate",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local tsconfig = safe_require("nvim-treesitter.configs")

		if not tsconfig then
			return
		end

		local get_config = require("nebula.helpers.require").get_user_config

		tsconfig.setup(get_config("treesitter"))
	end,
}
