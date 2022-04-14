local plugin = require("nebula.helpers.plugins").nebula_plugin

return {
	"https://github.com/neovim/nvim-lspconfig",
	requires = {
		plugin("lsp.installer"),
	},
	config = function()
		local get_config = require("nebula.helpers.require").get_user_config
		local lsp_config = get_config("lsp")

		for _, sign in ipairs(lsp_config.signs) do
			vim.fn.sign_define(
				sign.name,
				{ texthl = sign.name, text = sign.text, numhl = "" }
			)
		end

		vim.diagnostic.config(lsp_config.config)
	end,
}
