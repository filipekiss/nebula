local log = require("nebula.log")
local plugins = {
	user_plugins = {},
}

function plugins.colorscheme(colorscheme_name)
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
	local colorscheme_config = vim.tbl_extend(
		"keep",
		user_colorscheme or {},
		nebula_colorscheme or {}
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
	plugins.user_plugins[colorscheme_name] = colorscheme_config
	return colorscheme_config
end

function plugins.plugin(plugin_name)
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
	local plugin_config = vim.tbl_extend(
		"keep",
		user_plugin or {},
		nebula_plugin or {}
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
	plugins.user_plugins[plugin_name] = plugin_config
	return plugin_config
end

return plugins