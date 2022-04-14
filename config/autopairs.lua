return {
	check_ts = true, -- check for TreeSitter support, see https://github.com/windwp/nvim-autopairs#treesitter
	ts_config = {
		lua = { "string", "source" },
		javascript = { "string", "template_string" },
	},
	disable_filetype = { "TelescopePrompt" },
}
