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
	return str:match("(.*)/")
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
	require("nebula.plugins")

	local packer = safe_require("packer")

	if not packer then
		log.warn("Packer not found, aborting plugin initialization…")
		return
	end

	local packer_config = plugin("packer")

	local plugins_helper = require("nebula.helpers.plugins")
	local nebula_plugins = plugins_helper.nebula_plugins
	local nebula_plugins_order = plugins_helper.nebula_plugins_order
	local user_plugins = plugins_helper.user_plugins
	local user_plugins_order = plugins_helper.user_plugins_order
	Nebula.all_plugins = vim.tbl_extend(
		"force",
		nebula_plugins_order,
		user_plugins_order
	)

	packer.init(packer_config)
	packer.reset()

	for _, plugin_name in ipairs(Nebula.all_plugins) do
		-- Check if the plugins has been disabled in Nebula.options
		if Nebula.options.active_plugins[plugin_name] == false then
			log.info(string.format("%s is disabled, skipping", plugin_name))
			goto skip_to_next
		end
		local plugin_config = {}
		-- Check if this is a Nebula plugin
		if type(nebula_plugins[plugin_name]) == "table" then
			plugin_config = vim.tbl_deep_extend(
				"force",
				plugin_config,
				nebula_plugins[plugin_name]
			)
		end
		log.trace(string.format("Adding %s to packer plugin list", plugin_name))
		if user_plugins[plugin_name] then
			log.trace(
				string.format("Loaded user configuration for %s", plugin_name)
			)
		end
		packer.use(plugin_config)
		-- This is used to skip calculations if a plugin is disabled
		::skip_to_next::
	end

	if PACKER_BOOTSTRAP and Nebula.options.auto_sync_packer then
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
	log.debug("Bootstraping Nebula")
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
	Nebula.path = script_path()
	log.debug("Nebula Path: " .. Nebula.path)
	log.debug("Log Level: " .. NEBULA_LOG_LEVEL)
	log.debug("Initiating Nebula")

	if Nebula.options.enable_settings == true then
		log.debug("Loading Settings")
		Nebula.load_settings()
	else
		log.debug("Nebula Settings disabled. Skipping…")
	end

	if Nebula.options.enable_mappings == true then
		log.debug("Loading Nebula Mappings")
		Nebula.load_mappings()
	else
		log.debug("Nebula Mappings disabled. Skipping…")
	end

	if Nebula.options.enable_plugins == true then
		log.debug("Loading Plugins")
		Nebula.load_plugins()
	else
		log.debug("Nebula Plugins disabled. Skipping…")
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
