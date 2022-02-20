local log = require("nebula.log")
local get_config = require("nebula.helpers.require").get_config

local nebula = {}

local function script_path()
	local str = debug.getinfo(2, "S").source:sub(2)
	return str:match("(.*/)")
end

log.debug("Bootstraping Nebula")
nebula.path = script_path()
vim.g.nebula_path = nebula.path
log.debug("Nebula Path: " .. nebula.path)
-- if not set yet, set the log level as error
if not vim.g.nebula_log_level then
	vim.g.nebula_log_level = "error"
end
log.debug("Log Level: " .. vim.g.nebula_log_level)

-- Load Nebula settings
-- These settings are the ones that change how Neovim behaves
-- Check the file lua/nebula/settings.lua for more info
local change_setting = require("nebula.helpers.settings").change_setting
local settings = get_config("settings")
for setting_name, setting_value in pairs(settings) do
	change_setting(setting_name, setting_value)
end

return nebula
