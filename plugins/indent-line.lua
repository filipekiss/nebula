return {
	"https://github.com/lukas-reineke/indent-blankline.nvim",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local indentline = safe_require("indent_blankline")

		if not indentline then
			return
		end

		indentline.setup({
			enabled = 1,
			show_trailing_blankline_indent = false,
			show_first_indent_level = true,
			use_treesitter = true,
			show_current_context = true,
			show_current_context_start = false,
			char = "▏",
			buftype_exclude = {
				"nofile",
				"terminal",
				"lsp-installer",
				"lspinfo",
			},
			filetype_exclude = {
				"help",
				"startify",
				"dashboard",
				"packer",
				"neogitstatus",
				"NvimTree",
				"neo-tree",
				"Trouble",
			},
			context_patterns = {
				"class",
				"return",
				"function",
				"method",
				"^if",
				"^while",
				"jsx_element",
				"^for",
				"^object",
				"^table",
				"block",
				"arguments",
				"if_statement",
				"else_clause",
				"jsx_element",
				"jsx_self_closing_element",
				"try_statement",
				"catch_clause",
				"import_statement",
				"operation_type",
			},
		})
	end,
}
