local plugin = require("nebula.helpers.plugins").plugin

local lsp_config = {
	"https://github.com/neovim/nvim-lspconfig",
	requires = {
		plugin("lsp.installer"),
	},
	config = function()
		-- Customize the LSP signs
		local signs = {
			{ name = "DiagnosticSignError", text = "" },
			{ name = "DiagnosticSignWarn", text = "" },
			{ name = "DiagnosticSignHint", text = "" },
			{ name = "DiagnosticSignInfo", text = "" },
		}

		for _, sign in ipairs(signs) do
			vim.fn.sign_define(
				sign.name,
				{ texthl = sign.name, text = sign.text, numhl = "" }
			)
		end

		local config = {
			-- disable virtual text
			virtual_text = false,
			-- show signs
			signs = {
				active = signs,
			},
			update_in_insert = true,
			underline = true,
			severity_sort = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		}

		vim.diagnostic.config(config)

		-- Auto format on save
		vim.g.lsp_format_on_save = 1
	end,
}

return lsp_config
