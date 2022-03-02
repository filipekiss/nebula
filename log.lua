-- modified from https://github.com/rxi/log.lua
local log = {}

log.level = NEBULA_LOG_LEVEL or "error" -- use error by default
log.prev_level = log.level

local modes = {
	{ name = "trace" },
	{ name = "debug" },
	{ name = "info" },
	{ name = "warn" },
	{ name = "error" },
	{ name = "fatal" },
}

local levels = {}
for i, v in ipairs(modes) do
	levels[v.name] = i
end
log.levels = levels

local round = function(x, increment)
	increment = increment or 1
	x = x / increment
	return (x > 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)) * increment
end

local _tostring = tostring

local tostring = function(...)
	local t = {}
	for i = 1, select("#", ...) do
		local x = select(i, ...)
		if type(x) == "number" then
			x = round(x, 0.01)
		end
		t[#t + 1] = _tostring(x)
	end
	return table.concat(t, " ")
end

log.restore_level = function()
	log.level = log.prev_level
end

log.temporary_level = function(new_level)
	log.prev_level = log.level
	if log.levels[log.prev_level] > log.levels[new_level] then
		log.level = new_level
	end
end

for i, x in ipairs(modes) do
	local nameupper = x.name:upper()
	log[x.name] = function(...)
		-- Return early if we're below the log level
		if i < levels[log.level] then
			return
		end

		local msg = tostring(...)
		local info = debug.getinfo(2, "Sl")
		local lineinfo = info.short_src .. ":" .. info.currentline

		-- Output to console
		print(
			string.format(
				"[%-6s%s] %s: %s",
				nameupper,
				os.date("%H:%M:%S"),
				lineinfo,
				msg
			)
		)
	end
end

return log
