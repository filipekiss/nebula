local log = require("nebula.log")
local mapping_helper = {}

local mapping_modes = {
	n = "Normal",
	v = "Visual and Select",
	s = "Select",
	x = "Visual",
	o = "Operator-pending",
	m = "Insert and Command-line",
	i = "Insert",
	l = "Insert, Command-line, Lang-Arg",
	c = "Command-line",
	t = "Terminal",
}

local is_mapped = function(mode, mapping)
	local mapped = vim.fn.maparg(mapping, mode)
	if mapped and mapped ~= "" then
		return mapped
	end
	return nil
end

mapping_helper.is_mapped = is_mapped

mapping_helper.keymap = function(mode, from, to, options)
	local used_options = options or {}
	if used_options.no_override and used_options.no_override == true then
		local mapped = is_mapped(mode, from)
		if mapped then
			log.debug(
				string.format(
					"Tried to map %s to %s in %s mode, but %s is already mapped to %s",
					from,
					to,
					mapping_modes[mode] or "NVO",
					from,
					mapped
				)
			)
			return
		end
		used_options["no_override"] = nil
	end
	if used_options.buffer == true then
		used_options["buffer"] = nil
		local bufnr = vim.api.nvim_win_get_buf(0)
		return vim.api.nvim_buf_set_keymap(bufnr, mode, from, to, used_options)
	end
	return vim.api.nvim_set_keymap(mode, from, to, used_options)
end

function mapping_helper.leader(leader_key)
	if vim.g.mapleader then
		log.info(string.format([[Leader is Mapped to <%s>, will not remap…]], vim.g.mapleader))
		return
	end
	vim.g.mapleader = leader_key
end

function mapping_helper.localleader(leader_key)
	if vim.g.maplocalleader then
		log.info(string.format([[Local Leader is Mapped to <%s>, will not remap…]], vim.g.maplocalleader))
		return
	end
	vim.g.maplocalleader = leader_key
end

-- makemapper is a wrapper function fo make it easier to create mappings for different modes
-- refer to the mapping functions defined afterwards to see how it works
local function makemapper(mode, default_opts)
	default_opts = default_opts or {}
	return function(from, to, opts)
		opts = opts or {}
		local used_options = vim.tbl_extend("force", default_opts, opts)
		return mapping_helper.keymap(mode, from, to, used_options)
	end
end

mapping_helper.makemapper = makemapper

-- Since table.unpack might not be available, use a custom implementation
-- taken from http://lua-users.org/wiki/CopyTable
local function unpack(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == "table" then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[unpack(orig_key)] = unpack(orig_value)
		end
		setmetatable(copy, unpack(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

-- this function is a helper to update the options object
-- it takes a key and a value and returns the function that will update the
-- passed options object
--
-- ```
-- local silent = update_options("silent", true)
-- local expr = update_options("expr", true)
-- silent({}) -- { silent = true }
-- silent(expr({})) -- { silent = true, expr = true }
-- expr({ "noremap" = true }) -- { noremap = true, expr = true }
-- ```
local function update_options(key, value)
	return function(input)
		local new_options = unpack(input or {})
		new_options[key] = value
		return new_options
	end
end

mapping_helper.opts = {}
mapping_helper.opts.silent = update_options("silent", true)
mapping_helper.opts.nosilent = update_options("silent", false)
mapping_helper.opts.remap = update_options("noremap", false)
mapping_helper.opts.noremap = update_options("noremap", true)
mapping_helper.opts.expr = update_options("expr", true)
mapping_helper.opts.noexpr = update_options("expr", false)
mapping_helper.opts.buffer = update_options("buffer", true)
mapping_helper.opts.nobuffer = update_options("buffer", false)
mapping_helper.opts.no_override = update_options("no_override", true)

-- each function is used to map to a specific mode…
-- …recursive global
local map_options = mapping_helper.opts.remap()
mapping_helper.map = makemapper("", map_options) -- recursive normal, visual, select and operator-pending
mapping_helper.nmap = makemapper("n", map_options) -- recursive normal mode
mapping_helper.imap = makemapper("i", map_options) -- recursive insert mode
mapping_helper.vmap = makemapper("v", map_options) -- recursive visual mode
mapping_helper.xmap = makemapper("x", map_options) -- recursive visual block mode (Ctrl-V)
mapping_helper.tmap = makemapper("t", map_options) -- recursive terminal mode
mapping_helper.cmap = makemapper("c", map_options) -- recursive command mode (When you type `:w` for example)
-- …non recursive global
map_options = mapping_helper.opts.noremap()
mapping_helper.noremmap = makemapper("", map_options) -- non-recursive normal, visual, select and operator-pending
mapping_helper.nnoremap = makemapper("n", map_options) -- non-recursive normal mode
mapping_helper.inoremap = makemapper("i", map_options) -- non-recursive insert mode
mapping_helper.vnoremap = makemapper("v", map_options) -- non-recursive visual mode
mapping_helper.xnoremap = makemapper("x", map_options) -- non-recursive visual block mode (Ctrl-V)
mapping_helper.tnoremap = makemapper("t", map_options) -- non-recursive terminal mode
mapping_helper.cnoremap = makemapper("c", map_options) -- non-recursive command mode (When you type `:w` for example)
-- …recursive buffer
map_options = mapping_helper.opts.buffer(mapping_helper.opts.remap())
mapping_helper.buf_map = makemapper("", map_options) -- normal, visual, select and operator-pending mode for a single buffer
mapping_helper.buf_nmap = makemapper("n", map_options) -- normal mode for a single buffer
mapping_helper.buf_imap = makemapper("i", map_options) -- recursive insert mode for a single buffer
mapping_helper.buf_vmap = makemapper("v", map_options) -- recursive visual mode for a single buffer
mapping_helper.buf_xmap = makemapper("x", map_options) -- recursive visual block mode (Ctrl-V) for a single buffer
mapping_helper.buf_tmap = makemapper("t", map_options) -- recursive terminal mode for a single buffer
mapping_helper.buf_cmap = makemapper("c", map_options) -- recursive command mode (When you type `:w` for example) for a single buffer
-- …non recursive buffer
map_options = mapping_helper.opts.buffer(map_options)
mapping_helper.buf_noremap = makemapper("", map_options) -- non-recursive normal, visual, select and operator-pending mode for a single buffer
mapping_helper.buf_nnoremap = makemapper("n", map_options) -- non-recursive normal mode for a single buffer
mapping_helper.buf_inoremap = makemapper("i", map_options) -- non-recursive insert mode for a single buffer
mapping_helper.buf_vnoremap = makemapper("v", map_options) -- non-recursive visual mode for a single buffer
mapping_helper.buf_xnoremap = makemapper("x", map_options) -- non-recursive visual block mode (Ctrl-V) for a single buffer
mapping_helper.buf_tnoremap = makemapper("t", map_options) -- non-recursive terminal mode for a single buffer
mapping_helper.buf_cnoremap = makemapper("c", map_options) -- non-recursive command mode (When you type `:w` for example) for a single buffer

function mapping_helper.expr(str)
	return '"' .. str .. '"'
end

return mapping_helper
