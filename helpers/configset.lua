local config_set = {
	config_namespace_order = {},
}

local function register_configset(configset_namespace)
	table.insert(config_set.config_namespace_order, configset_namespace)
end

config_set.use = register_configset

return config_set
