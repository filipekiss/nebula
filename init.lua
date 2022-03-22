local log = require("nebula.log")
local get_config = require("nebula.helpers.require").get_config
local load_config = require("nebula.helpers.require").load_config
local is_mapped = require("nebula.helpers.mappings").is_mapped
local nebula_default_options = require("nebula.options")
local safe_require = require("nebula.helpers.require").safe_require
local plugin = require("nebula.helpers.plugins").plugin
local colorscheme = require("nebula.helpers.plugins").colorscheme

NEBULA_LOG_LEVEL = NEBULA_LOG_LEVEL or "error"

_G.Nebula = {
	options = nebula_default_options,
	default_colorscheme = "catppuccin",
	plugin_options = {},
}

Nebula.use = require("nebula.helpers.plugins").use

Nebula.plugin = plugin
Nebula.colorscheme = colorscheme

local function script_path()
	local str = debug.getinfo(2, "S").source:sub(2)
	return str:match("(.*/)")
end

Nebula.load_settings = function()
	-- Load Nebula settings
	-- These settings are the ones that change how Neovim behaves
	-- Check the file lua/nebula/settings.lua for more info
	local change_setting = require("nebula.helpers.settings").change_setting
	local settings = get_config("settings")
	for setting_name, setting_value in pairs(settings) do
		change_setting(setting_name, setting_value)
	end
end

Nebula.load_mappings = function()
	-- Load Nebula Mappings
	-- This is a small hack because Neovim maps <C-L> to clear the current search
	-- highlight, which is not a default Vim mapping. Since we want to provide our
	-- own <C-L> mapping but still not override any user mapping, we unmap it here.
	-- If you want to restore the default Neovim behavior, just set
	-- Nebula.no_remap_cl = true
	if not Nebula.no_remap_cl and is_mapped("n", "<C-L>") then
		vim.cmd([[unmap <C-L>]])
	else
		log.info("Nebula.no_remap_cl is set, skipping unmap…")
	end

	-- Load Nebula Mappings
	load_config("mappings")
end

Nebula.load_plugins = function()
	-- Load Nebula Plugins
	-- This is responsible for installing packer.nvim if not installed and loading
	-- the plugins
	local nebula_plugins = require("nebula.plugins")

	local packer = safe_require("packer")

	if not packer then
		log.warn("Packer not found, aborting plugin initialization…")
		return
	end

	local packer_config = {}

	if Nebula.options.packer_float_window == true then
		packer_config = vim.tbl_extend("keep", packer_config, {
			display = {
				open_fn = function()
					-- configure packer to use a floating window
					return require("packer.util").float({ border = "rounded" })
				end,
			},
		})
	end

	local user_plugins = require("nebula.helpers.plugins").user_plugins
	Nebula.all_plugins = vim.tbl_extend(
		"force",
		nebula_plugins,
		user_plugins,
		Nebula.options.active_plugins or {}
	)

	packer.init(packer_config)
	packer.reset()

	Nebula.active_plugins = {}

	for key, value in pairs(Nebula.all_plugins) do
		if value == false then
			log.info(string.format("%s is disabled, skipping", key))
		end
		if type(value) == "table" then
			Nebula.active_plugins[key] = value
		end
	end

	for _, plugin_config in pairs(Nebula.active_plugins) do
		packer.use(plugin_config)
	end

	if PACKER_BOOTSTRAP then
		require("packer").sync()
		-- Try to apply the user colorscheme after everything is installed,
		-- otherwise use catppuccin
		vim.cmd(
			string.format(
				"autocmd User PackerComplete ++once colorscheme %s",
				Nebula.options.colorscheme or Nebula.default_colorscheme
			)
		)
	end
end

Nebula.init = function(options)
	if options then
		if type(options) ~= "table" then
			log.warn(
				string.format("Options: Table expected. Got %s", type(options))
			)
		else
			log.info("Updating Nebula Options during initialization...")
			Nebula.options = vim.tbl_extend("force", Nebula.options, options)
		end
	end
	log.debug("Bootstraping Nebula")
	Nebula.path = script_path()
	log.debug("Nebula Path: " .. Nebula.path)
	log.debug("Log Level: " .. NEBULA_LOG_LEVEL)

	log.debug("Initiating Nebula")

	if Nebula.options.enable_settings == true then
		log.debug("Loading Settings")
		Nebula.load_settings()
	end

	log.debug("Loading Mappings")
	Nebula.load_mappings()

	if Nebula.options.enable_plugins == true then
		log.debug("Loading Plugins")
		Nebula.load_plugins()
	end

	-- Try to apply the user set colorscheme
	-- Otherwise, apply Nebula's default

	vim.cmd(string.format(
		[[
  try
    colorscheme %s
  catch
    colorscheme darkblue
  endtry
  ]],
		Nebula.options.colorscheme or Nebula.default_colorscheme
	))
end

return Nebula
