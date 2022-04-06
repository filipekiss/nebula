local luasnip = {
	"https://github.com/L3MON4D3/LuaSnip",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local luasnip = safe_require("luasnip")
		if not luasnip then
			return
		end
		luasnip.config.set_config({
			region_check_events = "InsertEnter",
			delete_check_events = "TextChanged,InsertLeave",
		})
	end,
}

return luasnip
