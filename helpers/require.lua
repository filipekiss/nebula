local log = require("nebula.log")
local nebula_require = {}
local configset = require("nebula.helpers.configset")

nebula_require.safe_require = function(module_name)
	local present, module = pcall(require, module_name)
	if not present then
		return nil
	end
	return module
end

-- This function is used to load nebula config files
-- These files must always return a value to be used by some other function, so
-- we check if the module is not a table and return `nil`. If the required
-- module is a table, then return that table
nebula_require.table_require = function(module_name)
	local module = nebula_require.safe_require(module_name)
	if type(module) ~= "table" then
		return nil
	end
	return module
end

local get_configset_names = function(config_to_require)
	local config_sets = configset.config_namespace_order
	local config_names = {}
	for _, namespace in ipairs(config_sets) do
		local config_name = string.format("%s.%s", namespace, config_to_require)
		table.insert(config_names, config_name)
	end
	return config_names
end

local smart_require = function(file_to_require, req_fn)
	local config_names = get_configset_names(file_to_require)
	local merged_config = {}
	for _, config_name in ipairs(config_names) do
		log.debug("Looking for " .. config_name)
		local loaded_config = req_fn(config_name)
		if loaded_config then
			log.debug("Found file " .. config_name)
		else
			log.debug("Not found file " .. config_name)
		end
		if type(loaded_config) == "table" then
			merged_config = vim.tbl_deep_extend(
				"force",
				merged_config,
				loaded_config
			)
		end
	end
	if merged_config then
		return merged_config
	end
	log.warn("Requested file " .. file_to_require .. " but nothing was loaded.")
	return nil
end

nebula_require.get_setup_file = function(file_to_require)
	return smart_require(file_to_require, nebula_require.table_require)
end

nebula_require.load_setup_file = function(file_to_require)
	return smart_require(file_to_require, nebula_require.safe_require)
end

nebula_require.get_user_config = function(file_to_require)
	local uconfig = smart_require(
		"config." .. file_to_require,
		nebula_require.table_require
	)
	return uconfig or {}
end

return nebula_require
