local log = require("nebula.log")

local plugins_helper = {
	user_plugins = {},
	nebula_plugins = {},
	nebula_plugins_order = {},
	user_plugins_order = {},
}

local function register_plugin(
	plugin_namespace,
	order_table_ref,
	config_table_ref,
	plugin_name
)
	local table_require = require("nebula.helpers.require").table_require
	local next = next
	local user_namespace = Nebula.user_options.namespace or "user"
	local user_plugin_name = string.format(
		"%s.%s.%s",
		user_namespace,
		plugin_namespace,
		plugin_name
	)
	local nebula_plugin_name = string.format(
		"nebula.%s.%s",
		plugin_namespace,
		plugin_name
	)
	local user_plugin = table_require(user_plugin_name)
	local nebula_plugin = table_require(nebula_plugin_name)
	if user_plugin then
		log.trace(string.format("Found user plugin %s", user_plugin_name))
	end
	local plugin_config = vim.tbl_deep_extend(
		"force",
		nebula_plugin or {},
		user_plugin or {}
	)
	-- if the configuration is empty, return nil
	if next(plugin_config) == nil then
		log.warn(
			string.format(
				"Tried to load plugin '%s', but the configuration came up empty. You might have an error in your file",
				plugin_name
			)
		)
		return nil
	end
	table.insert(order_table_ref, plugin_name)
	config_table_ref[plugin_name] = plugin_config
	return plugin_config
end

local function register_user_plugin(plugin_name)
	return register_plugin(
		"plugins",
		plugins_helper.user_plugins_order,
		plugins_helper.user_plugins,
		plugin_name
	)
end

local function register_nebula_plugin(plugin_name)
	return register_plugin(
		"plugins",
		plugins_helper.nebula_plugins_order,
		plugins_helper.nebula_plugins,
		plugin_name
	)
end

local function register_user_colorscheme(plugin_name)
	return register_plugin(
		"colorschemes",
		plugins_helper.user_plugins_order,
		plugins_helper.user_plugins,
		plugin_name
	)
end

local function register_nebula_colorscheme(plugin_name)
	return register_plugin(
		"colorschemes",
		plugins_helper.nebula_plugins_order,
		plugins_helper.nebula_plugins,
		plugin_name
	)
end

plugins_helper.plugin = register_user_plugin
plugins_helper.colorscheme = register_user_colorscheme
plugins_helper.nebula_plugin = register_nebula_plugin
plugins_helper.nebula_colorscheme = register_nebula_colorscheme

return plugins_helper
