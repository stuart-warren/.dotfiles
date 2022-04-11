local status_ok, lspcontainers = pcall(require, "lspcontainers")
if not status_ok then
	return
end

return {
	before_init = function(params)
        params.processId = vim.NIL
    end,
    cmd = lspcontainers.command('bashls'),
}