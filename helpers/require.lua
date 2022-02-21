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
nebula_require.nrequire = function(module_name)
	local module = nebula_require.safe_require(module_name)
	if type(module) ~= "table" then
		return nil
	end
	return module
end

local get_config_names = function(config_name)
	local user_namespace = Nebula.user_namespace
	local nebula = string.format("nebula.%s", config_name)
	local user = string.format("%s.%s", user_namespace, config_name)
	return nebula, user
end

nebula_require.get_config = function(file_to_require)
	log.info("Requiring config file " .. file_to_require)
	local nebula_file, user_file = get_config_names(file_to_require)
	log.info("Looking for " .. user_file)
	local user_config = nebula_require.nrequire(user_file)
	if user_config then
		log.info("User config found for " .. file_to_require)
	else
		log.info("User config not found for " .. file_to_require)
	end
	if user_config and user_config.nebula_override == true then
		log.info("User config set to override")
		log.info("Ignoring Nebula config for " .. file_to_require)
		user_config["nebula_override"] = nil
		return user_config
	end
	log.info("Looking for " .. nebula_file)
	local nebula_config = nebula_require.nrequire(nebula_file)
	if nebula_config then
		log.info("Nebula config found for " .. file_to_require)
	else
		log.info("Nebula config not found for " .. file_to_require)
	end
	if nebula_config and user_config then
		log.info("Merging Nebula and User config for " .. file_to_require)
		return vim.tbl_extend("force", nebula_config, user_config)
	end
	if nebula_config then
		return nebula_config
	end
	log.warn("Requested config for " .. file_to_require .. " but none was found.")
end

nebula_require.load_config = function(file_to_require)
	log.info("Requiring config file " .. file_to_require)
	local nebula_file, user_file = get_config_names(file_to_require)
	log.info("Looking for " .. user_file)
	local user_config = nebula_require.safe_require(user_file)
	if user_config then
		log.info("User config found for " .. file_to_require)
	else
		log.info("User config not found for " .. file_to_require)
	end
	if type(user_config) == "table" and user_config.nebula_override == true then
		log.info("User config set to override")
		log.info("Ignoring Nebula config for " .. file_to_require)
		user_config["nebula_override"] = nil
		return user_config
	end
	log.info("Looking for " .. nebula_file)
	local nebula_config = nebula_require.safe_require(nebula_file)
	if nebula_config then
		log.info("Nebula config found for " .. file_to_require)
	else
		log.info("Nebula config not found for " .. file_to_require)
	end
	if type(nebula_config) == "table" and type(user_config) == "table" then
		log.info("Merging Nebula and User config for " .. file_to_require)
		return vim.tbl_extend("force", nebula_config, user_config)
	end
	if nebula_config then
		return nebula_config
	end
	log.warn("Requested config for " .. file_to_require .. " but none was found.")
end

return nebula_require
