local status_ok, lspcontainers = pcall(require, "lspcontainers")
if not status_ok then
	return
end

return {
	cmd = lspcontainers.command("sumneko_lua"),
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
}
