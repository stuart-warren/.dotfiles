local status_ok, lspcontainers = pcall(require, "lspcontainers")
if not status_ok then
	return
end

return {
    -- cmd = lspcontainers.command('gopls'), -- https://github.com/lspcontainers/dockerfiles/issues/65
    cmd = { 'gopls' },
}