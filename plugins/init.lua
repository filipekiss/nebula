local fn = vim.fn
local log = require("nebula.log")

if Nebula.options.install_packer then
	-- Set path to install packer
	local install_path = Nebula.options.packer_path

	-- Automatically install packer if not installed
	if fn.empty(fn.glob(install_path)) > 0 then
		PACKER_BOOTSTRAP = fn.system({
			"git",
			"clone",
			"--depth",
			"1",
			"https://github.com/wbthomason/packer.nvim",
			install_path,
		})
		log.info("Installing packer…")
		vim.cmd([[packadd packer.nvim]])
	end
end

local plugin = require("nebula.helpers.plugins").plugin
local colorscheme = require("nebula.helpers.plugins").colorscheme
local plugins = {
  packer = plugin("packer"),
  treesitter = plugin("treesitter"),
  catppuccin = colorscheme("catppuccin"),
}

return plugins
