local plugin = require("nebula.helpers.plugins").nebula_plugin

return {
	"https://github.com/nvim-telescope/telescope.nvim",
	requires = { plugin("plenary") },
	config = function()
		local telescope = require("telescope")

		local get_config = require("nebula.helpers.require").get_user_config
		telescope.setup(get_config("telescope"))
	end,
}
