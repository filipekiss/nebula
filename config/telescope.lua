local nnoremap = require("nebula.helpers.mappings").nnoremap

nnoremap("<leader><leader>", "<cmd>Telescope find_files<CR>")
nnoremap("<tab>", "<cmd>Telescope buffers<CR>")
nnoremap("<leader>fh", "<cmd>Telescope oldfiles<CR>")
nnoremap("<leader>fg", "<cmd>Telescope live_grep<CR>")
nnoremap("<leader>fd", "<cmd>Telescope diagnostics<CR>")

local actions = require("telescope.actions")
return {
	defaults = {
		prompt_prefix = " ",
		selection_caret = " ",
		path_display = { "smart" },
		sorting_strategy = "ascending",
		layout_strategy = "horizontal",
		layout_config = {
			horizontal = {
				prompt_position = "top",
				preview_width = 0.55,
				results_width = 0.8,
			},
			vertical = { mirror = false },
			width = 0.87,
			height = 0.80,
			preview_cutoff = 0,
		},

		mappings = {
			i = {
				["<esc>"] = actions.close,
				["<tab>"] = actions.toggle_selection
					+ actions.move_selection_next,
				["<s-tab>"] = actions.toggle_selection
					+ actions.move_selection_previous,
				["<CR>"] = actions.select_default,
				["<C-x>"] = actions.select_horizontal,
				["<C-v>"] = actions.select_vertical,
				["<C-t>"] = actions.select_tab,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
			},
			n = {
				["<esc>"] = actions.close,
				["<tab>"] = actions.toggle_selection
					+ actions.move_selection_next,
				["<s-tab>"] = actions.toggle_selection
					+ actions.move_selection_previous,
				["<CR>"] = actions.select_default,
				["<C-x>"] = actions.select_horizontal,
				["<C-v>"] = actions.select_vertical,
				["<C-t>"] = actions.select_tab,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["j"] = actions.move_selection_next,
				["k"] = actions.move_selection_previous,
			},
		},
	},
	pickers = {
		buffers = {
			ignore_current_buffer = true,
			sort_lastused = true,
		},
		-- Default configuration for builtin pickers goes here:
		-- picker_name = {
		--   picker_config_key = value,
		--   ...
		-- }
		-- Now the picker_config_key will be applied every time you call this
		-- builtin picker
	},
	extensions = {
		-- Your extension configuration goes here:
		-- extension_name = {
		--   extension_config_key = value,
		-- }
		-- please take a look at the readme of the extension you want to configure
	},
}
