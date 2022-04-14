local fn = vim.fn
local log = require("nebula.log")

if Nebula.options.install_packer then
	-- Set path to install packer
	local install_path = Nebula.options.packer_path

	-- Automatically install packer if not installed
	if fn.empty(fn.glob(install_path)) > 0 then
		log.temporary_level("info")
		log.info("packer.nvim not found. Installing…")
		PACKER_BOOTSTRAP = fn.system({
			"git",
			"clone",
			"--depth",
			"1",
			"https://github.com/wbthomason/packer.nvim",
			install_path,
			"-q",
		})
		vim.cmd([[redraw!]])
		log.info("packer.nvim installed. Installing plugins…")
		log.restore_level()
		vim.cmd([[packadd packer.nvim]])
	end
end

local plugin = require("nebula.helpers.plugins").nebula_plugin
local colorscheme = require("nebula.helpers.plugins").nebula_colorscheme
-- use the helpers to register the plugins
plugin("packer")
plugin("treesitter")
plugin("autopairs")
plugin("autotag")
plugin("comment")
plugin("telescope")
plugin("completion")
plugin("lsp")
plugin("filetype")
plugin("fix-cursor-hold")
plugin("rainbow")
plugin("alpha")
plugin("gitsigns")
plugin("neoscroll")
plugin("which-key")
plugin("indent-line")
plugin("colorizer")
plugin("null-ls")
plugin("toggleterm")
colorscheme("catppuccin")
