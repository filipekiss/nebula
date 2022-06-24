local safe_require = require("nebula.helpers.require").safe_require
local cmp = safe_require("cmp")
if not cmp then
	return
end

local luasnip = safe_require("luasnip")

local check_backspace = function()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

local smart_completion = function(direction)
	if direction == "previous" then
		return function(fallback)
			if cmp.visible() then
				cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
			elseif luasnip.jumpable(-1) then
				vim.fn.feedkeys(
					vim.api.nvim_replace_termcodes(
						"<Plug>luasnip-jump-prev",
						true,
						true,
						true
					),
					""
				)
			else
				fallback()
			end
		end
	else
		return function(fallback)
			if cmp.visible() then
				cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
			elseif luasnip.expandable() then
				luasnip.expand()
			elseif luasnip.expand_or_locally_jumpable() then
				vim.fn.feedkeys(
					vim.api.nvim_replace_termcodes(
						"<Plug>luasnip-expand-or-jump",
						true,
						true,
						true
					),
					""
				)
			elseif check_backspace() then
				fallback()
			else
				fallback()
			end
		end
	end
end

return {
	smart_completion = smart_completion,
}
