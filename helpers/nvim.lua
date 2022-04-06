local nvim_helpers = {
	fns = {},
}

--[[
-- I use this function to register a lua function to the module. This way, I can
-- use lua functions in places like autocmd/mappings. This function is only used
-- locally and is not exported, is just used by other functions to
--]]
local function register_fn(fn)
	local fn_ref = tostring(fn)
	nvim_helpers.fns[fn_ref] = fn
	return fn_ref
end

function nvim_helpers.fn_imap(fn)
	local fn_ref = register_fn(fn)
	return string.format(
		[[<c-r>=luaeval("require('nebula.helpers.nvim').fns['%s']()")<CR>]],
		fn_ref
	)
end

function nvim_helpers.fn_cmd(fn, args)
	local fn_ref = register_fn(fn)
	return string.format(
		[[lua require('nebula.helpers.nvim').fns['%s'](%s)]],
		fn_ref,
		table.concat(args or {}, ", ")
	)
end

function nvim_helpers.fn_cmdmap(cmd)
	return string.format([[<cmd>%s<CR>]], cmd)
end

function nvim_helpers.execute_cmd(cmd)
	return string.format([[execute "%s"]], cmd)
end

function nvim_helpers.fn_command_string(name, command, opts)
	opts = opts or {}
	local is_lua_fn = type(command) == "function"
	local command_str = ""
	if is_lua_fn == true then
		command_str = nvim_helpers.fn_cmd(command, opts.cmd_args)
	else
		command_str = command
	end
	opts["cmd_args"] = nil
	return string.format(
		"command! %s %s %s",
		table.concat(opts, " "),
		name,
		command_str
	)
end

function nvim_helpers.add_user_command(name, command, opts)
	return vim.cmd(nvim_helpers.fn_command_string(name, command, opts))
end

function nvim_helpers.split_string(split_at, string)
	local result = {}
	for match in string:gmatch(string.format("[^%s]+", split_at)) do
		table.insert(result, match)
	end
	return result
end

return nvim_helpers
