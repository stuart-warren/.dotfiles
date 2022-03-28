-- local servers = { "bashls", "dockerls", "gopls", "html", "jsonls", "pyright", "sumneko_lua", "teraformls", "yamlls" }
local servers = { "jsonls", "pyright", "sumneko_lua", "yamlls" }

for _, server in ipairs(servers)
do
    require("lspconfig")[server].setup(require("user.plugins.lsp.servers." .. server))
end