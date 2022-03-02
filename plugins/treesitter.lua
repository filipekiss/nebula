local treesitter = {
	"https://github.com/nvim-treesitter/nvim-treesitter",
	run = ":TSUpdate",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local tsconfig = safe_require("nvim-treesitter.configs")

		if not tsconfig then
			return
		end

		tsconfig.setup({
			ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
			sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
			ignore_install = { "" }, -- List of parsers to ignore installing
			autopairs = {
				enable = true,
			},
			highlight = {
				enable = true, -- false will disable the whole extension
				disable = { "" }, -- list of language that will be disabled
				additional_vim_regex_highlighting = true,
			},
			indent = { enable = true, disable = { "yaml" } },
			context_commentstring = {
				enable = true,
				enable_autocmd = false,
			},
		})
	end,
}

return treesitter
