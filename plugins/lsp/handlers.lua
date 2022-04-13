local safe_require = require("nebula.helpers.require").safe_require

local common = { capabilities = nil }
local function lsp_highlight_document(client)
	-- Set autocommands conditional on server_capabilities
	if client.resolved_capabilities.document_highlight then
		local augroup = require("nebula.helpers.autocmd").augroup
		local fn_cmd = require("nebula.helpers.nvim").fn_cmd
		augroup("LspHighlight", {
			{
				events = { "CursorHold" },
				command = fn_cmd(vim.lsp.buf.document_highlight),
			},
			{
				events = { "CursorMoved" },
				command = fn_cmd(vim.lsp.buf.clear_references),
			},
		}, { buffer = true })
	end
end

local function lsp_mappings(bufnr)
	local nnoremap = require("nebula.helpers.mappings").nnoremap
	local make_opts = require("nebula.helpers.mappings").opts
	local opts = make_opts.silent({ buffer = bufnr })
	nnoremap("gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	nnoremap("gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	nnoremap("K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	nnoremap("gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	nnoremap("<leader>K", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	nnoremap("<leader>cr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	nnoremap("gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	nnoremap("<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	nnoremap(
		"[d",
		'<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>',
		opts
	)
	nnoremap(
		"gl",
		'<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ border = "rounded" })<CR>',
		opts
	)
	nnoremap(
		"]d",
		'<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>',
		opts
	)
	nnoremap("<leader>l", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
	require("nebula.helpers.nvim").add_user_command(
		"Format",
		vim.lsp.buf.formatting
	)
end

local format_on_save = function()
	local global_save = vim.g.lsp_format_on_save
	local buffer_save = vim.b.lsp_format_on_save
	if global_save == 1 or buffer_save == 1 then
		vim.lsp.buf.formatting_seq_sync()
	end
end

local function lsp_format(client)
	if not Nebula.options.lsp.format_on_save then
		return
	end
	local fn_cmd = require("nebula.helpers.nvim").fn_cmd
	if client.resolved_capabilities.document_formatting then
		local augroup = require("nebula.helpers.autocmd").augroup
		augroup("NebulaLspFormatting", {
			{
				events = { "BufWritePre" },
				targets = { "<buffer>" },
				command = fn_cmd(format_on_save),
			},
		}, { buffer = true })
	end
end

function common.on_attach(client, bufnr)
	lsp_mappings(bufnr)
	lsp_highlight_document(client)
	lsp_format(client)
end

-- https://github.com/hrsh7th/cmp-nvim-lsp#setup
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_lsp = safe_require("cmp_nvim_lsp")
-- if cmp is not installed, return the common config up until this point
if not cmp_lsp then
	return common
end

local cmp_lsp_capabilities = cmp_lsp.update_capabilities(capabilities) or {}
common.capabilities = cmp_lsp_capabilities

return common
