local log = require("nebula.log")
local get_setup = require("nebula.helpers.require").get_setup_file
local load_setup = require("nebula.helpers.require").load_setup_file
local safe_require = require("nebula.helpers.require").safe_require
local get_config = require("nebula.helpers.require").get_user_config
local plugin = require("nebula.helpers.plugins").plugin
local colorscheme = require("nebula.helpers.plugins").colorscheme
local augroup = require("nebula.helpers.autocmd").augroup
local autocmd = require("nebula.helpers.autocmd").autocmd
local configset = require("nebula.helpers.configset")

NEBULA_LOG_LEVEL = NEBULA_LOG_LEVEL or "error"

_G.Nebula = {
	user_options = {},
	plugin_options = {},
}

Nebula.plugin = plugin
Nebula.colorscheme = colorscheme
Nebula.augroup = augroup
Nebula.autocmd = autocmd
Nebula.configset = configset.use
Nebula.get_config = get_config

local function script_path()
	local str = debug.getinfo(2, "S").source:sub(2)
	return str:match("(.*)/")
end

Nebula.load_settings = function()
	-- Load Nebula settings
	-- These settings are the ones that change how Neovim behaves
	-- Check the file lua/nebula/settings.lua for more info
	local settings = get_setup("settings")
	local change_setting = require("nebula.helpers.settings").change_setting
	for setting_name, setting_value in pairs(settings) do
		change_setting(setting_name, setting_value)
	end
end

Nebula.load_mappings = function()
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
	end

	-- After all plugins have been added, clear Nebula.all_plugins so we can add
	-- new plugins in runtime without restarting Neovim
	Nebula.configured_plugins = Nebula.all_plugins
	Nebula.all_plugins = {}

	if PACKER_BOOTSTRAP then
		require("packer").sync()
		-- Try to apply the user colorscheme after everything is installed,
		-- otherwise use catppuccin
		if Nebula.user_options.colorscheme ~= nil then
			vim.cmd(
				string.format(
					"autocmd User PackerComplete ++once colorscheme %s",
					Nebula.user_options.colorscheme
						or Nebula.default_colorscheme
				)
			)
		end
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
			Nebula.user_options = vim.tbl_extend(
				"force",
				Nebula.user_options,
				options
			)
		end
	end
	Nebula.path = script_path()
	log.debug("Nebula Path: " .. Nebula.path)
	log.debug("Log Level: " .. NEBULA_LOG_LEVEL)
	log.debug("Initiating Nebula")

	if next(configset.config_namespace_order) == nil then
		log.warn('Configset is empty, using "user" by default...')
		configset.use("user")
	end

	log.debug("Loading Settings")
	Nebula.load_settings()

	log.debug("Loading Nebula Mappings")
	Nebula.load_mappings()

	log.debug("Loading Plugins")
	Nebula.load_plugins()

	log.debug("Registering autocmd")
	load_setup("autocmd")

	log.debug("Registering commands")
	if not Nebula.user_options.disable_commands then
		require("nebula.commands")
	end
	load_setup("commands")

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
		Nebula.user_options.colorscheme or "darkblue"
	))
end

return Nebula
