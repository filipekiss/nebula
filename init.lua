local log = require("nebula.log")
local get_config = require("nebula.helpers.require").get_config
local load_config = require("nebula.helpers.require").load_config
local is_mapped = require("nebula.helpers.mappings").is_mapped
local nebula_default_options = require("nebula.options")

-- If there's a global `Nebula` var, use that, if not, create a new one
_G.Nebula = _G.Nebula or {}

Nebula = vim.tbl_extend("keep", Nebula, nebula_default_options)

log.trace(vim.inspect(Nebula))

local function script_path()
	local str = debug.getinfo(2, "S").source:sub(2)
	return str:match("(.*/)")
end

log.debug("Bootstraping Nebula")
Nebula.path = script_path()
log.debug("Nebula Path: " .. Nebula.path)
-- if not set yet, set the log level as error
if not Nebula.log_level then
	Nebula.log_level = "error"
end
log.debug("Log Level: " .. Nebula.log_level)

-- Load Nebula settings
-- These settings are the ones that change how Neovim behaves
-- Check the file lua/nebula/settings.lua for more info
local change_setting = require("nebula.helpers.settings").change_setting
local settings = get_config("settings")
for setting_name, setting_value in pairs(settings) do
	change_setting(setting_name, setting_value)
end

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
load_config("mappings")
