return {
	"https://github.com/folke/trouble.nvim",
	requires = { "https://github.com/folke/lsp-colors.nvim" },
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local trouble = safe_require("trouble")

		if not trouble then
			return
		end

		trouble.setup()
	end,
}
