return {
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
	rainbow = { -- configuration for rainbow parenthesis https://github.com/p00f/nvim-ts-rainbow#installation-and-setup
		enable = true,
		extended_mode = true,
		max_file_lines = 5000, -- disable for files longer than 5000 lines
	},
}
