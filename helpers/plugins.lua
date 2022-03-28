local log = require("nebula.log")

local plugins_helper = {
	user_plugins = {},
}

function plugins_helper.colorscheme(colorscheme_name)
	local table_require = require("nebula.helpers.require").table_require
	local next = next
	local user_namespace = Nebula.options.user_namespace
	local user_colorscheme_name = string.format(
		"%s.colorschemes.%s",
		user_namespace,
		colorscheme_name
	)
	local nebula_colorscheme_name = string.format(
		"nebula.colorschemes.%s",
		colorscheme_name
	)
	local user_colorscheme = table_require(user_colorscheme_name)
	local nebula_colorscheme = table_require(nebula_colorscheme_name)
	if user_colorscheme then
		log.trace(
			string.format("Found user colorscheme %s", user_colorscheme_name)
		)
	end
	local colorscheme_config = vim.tbl_deep_extend(
		"force",
		nebula_colorscheme or {},
		user_colorscheme or {}
	)
	-- if the configuration is empty, return nil
	if next(colorscheme_config) == nil then
		log.warn(
			string.format(
				"Tried to load colorscheme '%s', but no colorscheme with that name was found",
				colorscheme_name
			)
		)
		return nil
	end
	plugins_helper.user_plugins[colorscheme_name] = colorscheme_config
	return colorscheme_config
end

function plugins_helper.plugin(plugin_name)
	local table_require = require("nebula.helpers.require").table_require
	local next = next
	local user_namespace = Nebula.options.user_namespace
	local user_plugin_name = string.format(
		"%s.plugins.%s",
		user_namespace,
		plugin_name
	)
	local nebula_plugin_name = string.format("nebula.plugins.%s", plugin_name)
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
				"Tried to load plugin '%s', but no plugin with that name was found",
				plugin_name
			)
		)
		return nil
	end
	plugins_helper.user_plugins[plugin_name] = plugin_config
	return plugin_config
end

return plugins_helper
