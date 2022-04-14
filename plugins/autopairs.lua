return {
	"https://github.com/windwp/nvim-autopairs",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local autopairs = safe_require("nvim-autopairs")
		if not autopairs then
			return
		end

		local get_config = require("nebula.helpers.require").get_user_config
		autopairs.setup(get_config("autopairs"))

		-- if cmp is enabled, hook autopairs with cmp
		-- see https://github.com/windwp/nvim-autopairs#you-need-to-add-mapping-cr-on-nvim-cmp-setupcheck-readmemd-on-nvim-cmp-repo
		local cmp = safe_require("cmp")
		if not cmp then
			return
		end
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		cmp.event:on(
			"confirm_done",
			cmp_autopairs.on_confirm_done({ map_char = { tex = "" } })
		)
	end,
}
