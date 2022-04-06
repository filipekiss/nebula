return {
	"https://github.com/antoinemadec/FixCursorHold.nvim",
	config = function()
		vim.g.cursorshold_updatetime = Nebula.options.cursorhold
	end,
	event = { "BufRead", "BufNewFile" },
}
