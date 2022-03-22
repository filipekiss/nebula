local comment = {
	"https://github.com/numToStr/Comment.nvim",
	config = function()
		local comment = require("Comment")
		comment.setup({
			ignore = "^$", -- don't comment empty lines
			pre_hook = function(ctx)
				-- https://github.com/numToStr/Comment.nvim#-hooks
				-- uses JoosepAlviste/nvim-ts-context-commentstring
				local U = require("Comment.utils")

				local location = nil
				if ctx.ctype == U.ctype.block then
					location =
						require("ts_context_commentstring.utils").get_cursor_location()
				elseif
					ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V
				then
					location =
						require("ts_context_commentstring.utils").get_visual_start_location()
				end

				return require("ts_context_commentstring.internal").calculate_commentstring({
					key = ctx.ctype == U.ctype.line and "__default"
						or "__multiline",
					location = location,
				})
			end,
		})
	end,
	requires = {
		"https://github.com/JoosepAlviste/nvim-ts-context-commentstring", -- add support for jsx comment strings
	},
}

return comment
