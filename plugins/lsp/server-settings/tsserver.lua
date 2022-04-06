local tsserver = {
	name = "tsserver",
	opts = {
		on_attach = function(client, bufnr)
			-- disable tsserver formatting, I'll use prettier with null-ls
			client.resolved_capabilities.document_formatting = false
		end,
	},
}

return tsserver
