local lsp_installer = {
	"https://github.com/williamboman/nvim-lsp-installer",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local lsp_installer = safe_require("nvim-lsp-installer")
		local lsp_installer_servers = safe_require("nvim-lsp-installer.servers")

		lsp_installer.settings({
			ui = {
				icons = {
					server_installed = "✓",
					server_pending = "➜",
					server_uninstalled = "✗",
				},
			},
		})

		lsp_installer.on_server_ready(function(server)
			local opts = server:get_default_options()
			opts.on_attach = require("nebula.plugins.lsp.handlers").on_attach
			opts.capabilities =
				require("nebula.plugins.lsp.handlers").capabilities

			-- check if we have Nebula configurations for this server
			local table_require =
				require("nebula.helpers.require").table_require
			local nebula_server_settings = table_require(
				"nebula.plugins.lsp.server-settings." .. server.name
			)

			if nebula_server_settings then
				opts = vim.tbl_deep_extend(
					"force",
					nebula_server_settings,
					opts
				)
			end

			server:setup(opts)
		end)
	end,
}

return lsp_installer
