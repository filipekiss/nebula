return {
	"https://github.com/nathom/filetype.nvim",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local filetype = safe_require("filetype")

		if not filetype then
			return
		end

		if vim.fn.has("nvim-0.6") == 0 then
			vim.g.did_load_filetypes = 1
		end

		filetype.setup({})
	end,
}
