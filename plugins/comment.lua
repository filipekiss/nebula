return {
	"https://github.com/numToStr/Comment.nvim",
	config = function()
		local comment = require("Comment")
		local get_config = require("nebula.helpers.require").get_user_config

		comment.setup(get_config("comment"))
	end,
	requires = {
		"https://github.com/JoosepAlviste/nvim-ts-context-commentstring", -- add support for jsx comment strings
	},
}
