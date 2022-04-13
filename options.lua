-- These are the default options that are loaded during the bootstraping phase.
-- If you're looking for Neovim options, check the `settings.lua` file
local fn = vim.fn

local nebula_options = {
	leader = " ",
	enable_autocmd = true,
	enable_mappings = true,
	enable_plugins = true,
	enable_settings = true,
	user_namespace = "user",
	install_packer = true,
	auto_sync_packer = true,
	packer_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim",
	packer_float_window = true,
	active_plugins = {},
	lsp = {
		format_on_save = true,
	},
	cursorhold = 100,
}

return nebula_options
