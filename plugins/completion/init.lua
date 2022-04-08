local plugin = require("nebula.helpers.plugins").nebula_plugin
local completion = {
	"https://github.com/hrsh7th/nvim-cmp", -- The completion plugin

	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local cmp = safe_require("cmp")
		if not cmp then
			return
		end
		local cmp_buffer = safe_require("cmp_buffer")

		local luasnip = safe_require("luasnip")
		if luasnip then
			require("luasnip/loaders/from_vscode").lazy_load()
		end

		local check_backspace = function()
			local col = vim.fn.col(".") - 1
			return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
		end

		local smart_completion = function(direction)
			if direction == "previous" then
				return function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
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
						cmp.select_next_item()
					elseif luasnip.expandable() then
						luasnip.expand()
					elseif luasnip.expand_or_jumpable() then
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

		local kind_icons = {
			Text = "",
			Method = "m",
			Function = "",
			Constructor = "",
			Field = "",
			Variable = "",
			Class = "",
			Interface = "",
			Module = "",
			Property = "",
			Unit = "",
			Value = "",
			Enum = "",
			Keyword = "",
			Snippet = "",
			Color = "",
			File = "",
			Reference = "",
			Folder = "",
			EnumMember = "",
			Constant = "",
			Struct = "",
			Event = "",
			Operator = "",
			TypeParameter = "",
		}

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = {
				["<C-p>"] = cmp.mapping.select_prev_item(),
				["<C-n>"] = cmp.mapping.select_next_item(),
				["<C-d>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping({
					i = cmp.mapping.abort(),
					c = cmp.mapping.close(),
				}),
				["<CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				}),
				["<Tab>"] = cmp.mapping(smart_completion("next"), { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(
					smart_completion("previous"),
					{ "i", "s" }
				),
			},
			formatting = {
				fields = { "kind", "abbr", "menu" },
				format = function(entry, vim_item)
					-- Kind icons
					vim_item.kind = string.format(
						"%s",
						kind_icons[vim_item.kind]
					)
					-- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
					vim_item.menu = ({
						nvim_lsp = "[LSP]",
						luasnip = "[Snippet]",
						buffer = "[Buffer]",
						path = "[Path]",
					})[entry.source.name]
					return vim_item
				end,
			},
			sources = {
				{ name = "nvim_lsp" },
				{ name = "nvim_lua" },
				{ name = "luasnip" },
				{ name = "path" },
				{ name = "buffer" },
			},
			sorting = {
				comparators = {
					function(...)
						if cmp_buffer then
							return cmp_buffer:compare_locality(...)
						end
					end,
				},
			},
			confirm_opts = {
				behavior = cmp.ConfirmBehavior.Replace,
				select = false,
			},
			documentation = {
				border = {
					"╭",
					"─",
					"╮",
					"│",
					"╯",
					"─",
					"╰",
					"│",
				},
			},
			experimental = {
				ghost_text = false,
				native_menu = false,
			},
		})
	end,
	requires = {
		{ "https://github.com/hrsh7th/cmp-buffer" }, -- buffer completions
		{ "https://github.com/hrsh7th/cmp-path" }, -- path completions
		{ "https://github.com/hrsh7th/cmp-cmdline" }, -- cmdline completions
		{ "https://github.com/saadparwaiz1/cmp_luasnip" }, -- snippet completions
		plugin("completion.luasnip"),
		{ "https://github.com/rafamadriz/friendly-snippets" }, -- a bunch of snippets to use
		{ "https://github.com/hrsh7th/cmp-nvim-lua" }, -- complete neovim lua api
		{ "https://github.com/hrsh7th/cmp-nvim-lsp" }, -- complete from lsp sources
	},
}

return completion
