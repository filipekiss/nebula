local log = require("nebula.log")
local get_setup = require("nebula.helpers.require").get_setup_file
local load_setup = require("nebula.helpers.require").load_setup_file
local is_mapped = require("nebula.helpers.mappings").is_mapped
local nebula_default_options = require("nebula.options")
local safe_require = require("nebula.helpers.require").safe_require
local plugin = require("nebula.helpers.plugins").plugin
local colorscheme = require("nebula.helpers.plugins").colorscheme
local augroup = require("nebula.helpers.autocmd").augroup
local autocmd = require("nebula.helpers.autocmd").autocmd

NEBULA_LOG_LEVEL = NEBULA_LOG_LEVEL or "error"

_G.Nebula = {
	options = nebula_default_options,
	default_colorscheme = "catppuccin",
	plugin_options = {},
}

Nebula.use = require("nebula.helpers.plugins").use

Nebula.plugin = plugin
Nebula.colorscheme = colorscheme
Nebula.augroup = augroup
Nebula.autocmd = autocmd

local function script_path()
	local str = debug.getinfo(2, "S").source:sub(2)
	return str:match("(.*)/")
end

Nebula.load_settings = function()
	-- Load Nebula settings
	-- These settings are the ones that change how Neovim behaves
	-- Check the file lua/nebula/settings.lua for more info
	local change_setting = require("nebula.helpers.settings").change_setting
	local settings = get_setup("settings")
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
	load_setup("mappings")
end

Nebula.load_plugins = function()

	local packer = safe_require("packer")

	if not packer then
		log.warn("Packer not found, aborting plugin initialization…")
		return
	end

	local add_plugin_to_table = function(table_ref, plugin_name)
		-- only add if the table doesn't yet contain the plugin to avoid adding to
		-- packer twice
		if not vim.tbl_contains(table_ref, plugin_name) then
			table.insert(table_ref, plugin_name)
		end
	end

	local packer_config = plugin("packer")

	local plugins_helper = require("nebula.helpers.plugins")
	local nebula_plugins = plugins_helper.nebula_plugins
	local nebula_plugins_order = plugins_helper.nebula_plugins_order
	local user_plugins = plugins_helper.user_plugins
	local user_plugins_order = plugins_helper.user_plugins_order
	Nebula.all_plugins = Nebula.configured_plugins or {}
	for _, plugin_name in ipairs(nebula_plugins_order) do
		add_plugin_to_table(Nebula.all_plugins, plugin_name)
	end
	for _, plugin_name in ipairs(user_plugins_order) do
		add_plugin_to_table(Nebula.all_plugins, plugin_name)
	end

	packer.init(packer_config)
	packer.reset()

	for _, plugin_name in ipairs(Nebula.all_plugins) do
		-- Check if the plugins has been disabled in Nebula.options
		if Nebula.options.active_plugins[plugin_name] == false then
			log.info(string.format("%s is disabled, skipping", plugin_name))
			goto skip_to_next
		end
		local plugin_config = {}
		local has_nebula_plugin = false
		-- Check if this is a Nebula plugin
		if type(nebula_plugins[plugin_name]) == "table" then
			log.debug(string.format("Loaded Nebula plugin %s", plugin_name))
			plugin_config = vim.tbl_deep_extend(
				"force",
				plugin_config,
				nebula_plugins[plugin_name]
			)
			has_nebula_plugin = true
		end
		if user_plugins[plugin_name] then
			log.debug(string.format("Loaded user plugin %s", plugin_name))
			plugin_config = vim.tbl_deep_extend(
				"force",
				plugin_config,
				user_plugins[plugin_name]
			)
			if has_nebula_plugin then
				log.debug(
					string.format(
						"Merged user configuration for %s",
						plugin_name
					)
				)
			end
		end
		log.debug(string.format("Adding %s to packer plugin list", plugin_name))

		packer.use(plugin_config)
		-- This is used to skip calculations if a plugin is disabled
		::skip_to_next::
	end

	-- After all plugins have been added, clear Nebula.all_plugins so we can add
	-- new plugins in runtime without restarting Neovim
	Nebula.configured_plugins = Nebula.all_plugins
	Nebula.all_plugins = {}

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

	if Nebula.options.enable_autocmd == true then
		log.debug("Registering Nebula autocmd")
		load_setup("autocmd")
	end

	if Nebula.options.enable_commands == true then
		log.debug("Registering Nebula commands")
		load_setup("commands")
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
