local plugin = require("nebula.helpers.plugins").nebula_plugin
return {
	"https://github.com/hrsh7th/nvim-cmp", -- The completion plugin

	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local cmp = safe_require("cmp")
		if not cmp then
			return
		end

		local get_user_config =
			require("nebula.helpers.require").get_user_config

		local cmp_config = get_user_config("completion")

		cmp.setup(cmp_config)
	end,
	requires = {
		{ "https://github.com/hrsh7th/cmp-buffer" }, -- buffer completions
		{ "https://github.com/hrsh7th/cmp-path" }, -- path completions
		{ "https://github.com/hrsh7th/cmp-cmdline" }, -- cmdline completions
		{ "https://github.com/saadparwaiz1/cmp_luasnip" }, -- snippet completions
		plugin("completion.luasnip"),
		{ "https://github.com/rafamadriz/friendly-snippets" }, -- a bunch of snippets to use
		{ "https://github.com/hrsh7th/cmp-nvim-lua" }, -- complete neovim lua api
		{ "https://github.com/hrsh7th/cmp-nvim-lsp" }, -- complete from lsp sources
	},
}
