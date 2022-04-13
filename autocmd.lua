local augroup = require("nebula.helpers.autocmd").augroup

augroup("NebulaProjectRoot", {
	{
		events = { "BufAdd", "BufEnter" },
		targets = { "*" },
		command = 'lua require("nebula.functions").set_project_dir()',
	},
})

augroup("NebulaRelativeNumber", {
	{
		events = { "InsertLeave", "BufAdd", "BufEnter" },
		targets = { "*" },
		command = 'lua require("nebula.functions").display_line_numbers("n")',
	},
	{

		events = { "InsertEnter" },
		targets = { "*" },
		command = 'lua require("nebula.functions").display_line_numbers("i")',
	},
})
