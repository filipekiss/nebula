local augroup = require("nebula.helpers.autocmd").augroup

augroup("NebulaProjectRoot", {
	{
		events = { "BufAdd", "BufEnter" },
		targets = { "*" },
		command = 'lua require("nebula.functions").set_project_dir()',
	},
})
