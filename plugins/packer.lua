local packer = {
	"https://github.com/wbthomason/packer.nvim",
}

if Nebula.options.packer_float_window == true then
	packer.display = {}
	packer.display.open_fn = function()
		-- configure packer to use a floating window
		return require("packer.util").float({ border = "rounded" })
	end
end

return packer
