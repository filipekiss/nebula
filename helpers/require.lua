local log = require("nebula.log")
local nebula_require = {}

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

local get_config_names = function(config_name)
	local user_namespace = Nebula.options.user_namespace
	local nebula = string.format("nebula.%s", config_name)
	local user = string.format("%s.%s", user_namespace, config_name)
	return nebula, user
end

nebula_require.get_setup_file = function(file_to_require)
	log.debug("Requiring setup file " .. file_to_require)
	local nebula_file, user_file = get_config_names(file_to_require)
	log.debug("Looking for " .. user_file)
	local user_config = nebula_require.table_require(user_file)
	if user_config then
		log.debug("User setup found for " .. file_to_require)
	else
		log.debug("User setup not found for " .. file_to_require)
	end
	if user_config and user_config.nebula_override == true then
		log.info(
			"User setup set to override. Ignoring Nebula setup for "
				.. file_to_require
		)
		user_config["nebula_override"] = nil
		return user_config
	end
	log.debug("Looking for " .. nebula_file)
	local nebula_config = nebula_require.table_require(nebula_file)
	if nebula_config then
		log.debug("Nebula setup found for " .. file_to_require)
	else
		log.debug("Nebula setup not found for " .. file_to_require)
	end
	if nebula_config and user_config then
		log.debug("Merging Nebula and User setup for " .. file_to_require)
		return vim.tbl_extend("force", nebula_config, user_config)
	end
	if nebula_config then
		return nebula_config
	end
	log.warn(
		"Requested setup for " .. file_to_require .. " but none was found."
	)
end

nebula_require.load_setup_file = function(file_to_require)
	log.debug("Requiring setup file " .. file_to_require)
	local nebula_file, user_file = get_config_names(file_to_require)
	log.debug("Looking for " .. user_file)
	local user_config = nebula_require.safe_require(user_file)
	if user_config then
		log.debug("User setup found for " .. file_to_require)
	else
		log.debug("User setup not found for " .. file_to_require)
	end
	if type(user_config) == "table" and user_config.nebula_override == true then
		log.info(
			"User setup set to override. Ignoring Nebula setup for "
				.. file_to_require
		)
		user_config["nebula_override"] = nil
		return user_config
	end
	log.debug("Looking for " .. nebula_file)
	local nebula_config = nebula_require.safe_require(nebula_file)
	if nebula_config then
		log.debug("Nebula setup found for " .. file_to_require)
	else
		log.debug("Nebula setup not found for " .. file_to_require)
	end
	if type(nebula_config) == "table" and type(user_config) == "table" then
		log.debug("Merging Nebula and User setup for " .. file_to_require)
		return vim.tbl_extend("force", nebula_config, user_config)
	end
	if nebula_config then
		return nebula_config
	end
	log.warn(
		"Requested setup for " .. file_to_require .. " but none was found."
	)
end

nebula_require.get_user_config = function(file_to_require)
	log.debug("Requiring config file " .. file_to_require)
	local nebula_file, user_file = get_config_names(
		"config." .. file_to_require
	)
	log.debug("Looking for " .. user_file)
	local user_config = nebula_require.table_require(user_file)
	if user_config then
		log.debug("User config found for " .. file_to_require)
	else
		log.debug("User config not found for " .. file_to_require)
	end
	if user_config and user_config.nebula_override == true then
		log.info(
			"User config set to override. Ignoring Nebula config for "
				.. file_to_require
		)
		user_config["nebula_override"] = nil
		return user_config
	end
	log.debug("Looking for " .. nebula_file)
	local nebula_config = nebula_require.table_require(nebula_file)
	if nebula_config then
		log.debug("Nebula config found for " .. file_to_require)
	else
		log.debug("Nebula config not found for " .. file_to_require)
	end
	if nebula_config and user_config then
		log.debug("Merging Nebula and User config for " .. file_to_require)
		return vim.tbl_deep_extend("force", nebula_config, user_config)
	end
  if user_config then
    return user_config
  end
	if nebula_config then
		return nebula_config
	end
	log.warn(
		"Requested config for " .. file_to_require .. " but none was found."
	)
	return {}
end

return nebula_require
