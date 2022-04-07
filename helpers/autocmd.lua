local autocmd = {}

-- commands is a table with the following keys:
-- events - A table listing which events to trigger the autocmd, see :h events
-- modifiers - A table to pass modifiers like ++once and ++nested, see :h autocmd for ++once and :h autocmd-nested for ++nested
-- targets - Where to apply the autocommands. Things like <buffer> and the file pattern should go here
-- command - The command you wish to run
function autocmd.autocmd(commands)
	local autocmd_str = "autocmd"
	if commands.bang == true then
		autocmd_str = autocmd_str .. "!"
	end
	vim.cmd(
		string.format(
			"%s %s %s %s %s",
			autocmd_str,
			table.concat(commands.events or {}, ","),
			table.concat(commands.targets or {}, ","),
			table.concat(commands.modifiers or {}, " "),
			commands.command
		)
	)
end

function autocmd.augroup(name, commands, opts)
	opts = opts or {}
	vim.cmd("augroup " .. name)
	-- if this is a buffer augroup, make sure we remove only things from the
	-- buffer
	if opts.buffer == true then
		vim.cmd("autocmd! * <buffer>")
	else
		-- otherwise remove all autocmds from the group
		vim.cmd("autocmd!")
	end
	for _, command in ipairs(commands) do
		autocmd.autocmd(command)
	end
	vim.cmd("augroup END")
end

return autocmd
