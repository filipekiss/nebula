local settings_helpers = {}

settings_helpers.change_setting = function(name, value)
	-- if the setting is a table, we use the append method
	-- see :h lua-vim-set for more info
	if type(value) == "table" then
		vim.opt[name]:append(value)
	else
		-- otherwise, just set the option
		vim.opt[name] = value
	end
end

return settings_helpers
