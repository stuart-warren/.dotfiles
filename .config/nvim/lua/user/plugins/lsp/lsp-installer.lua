-- local servers = { "bashls", "dockerls", "gopls", "html", "jsonls", "pyright", "sumneko_lua", "teraformls", "yamlls" }
local servers = { "bashls", "dockerls", "gopls", "html", "jsonls", "pyright", "sumneko_lua", "yamlls" }
local handlers = require("user.plugins.lsp.handlers")

for _, server in ipairs(servers)
do
    local server_conf = "user.plugins.lsp.servers." .. server
    local server_opts = require(server_conf)
    local opts = {
        on_attach = handlers.on_attach,
        capabilities = handlers.capabilities,
    }
    opts = vim.tbl_deep_extend("force", server_opts, opts)
    require("lspconfig")[server].setup(opts)
end