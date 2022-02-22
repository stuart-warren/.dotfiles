
local default_schemas = nil
local extended_schemas = nil
local status_ok, yamlls_settings = pcall(require, "nlspsettings.loaders.yaml")
if status_ok then
  default_schemas = yamlls_settings.get_default_schemas()
end


local function extend(tab1, tab2)
  for _, value in ipairs(tab2) do
    table.insert(tab1, value)
  end
  return tab1
end

local status_ok, schemas = pcall(require, "user.lsp.settings.schemas")
if status_ok then
  extended_schemas = extend(schemas, default_schemas)
end

local opts = {
  settings = {
    yaml = {
      customTags = {
        "!fn",
        "!And",
        "!And sequence",
        "!If",
        "!If sequence",
        "!Not",
        "!Not sequence",
        "!Equals",
        "!Equals sequence",
        "!Or",
        "!Or sequence",
        "!FindInMap sequence",
        "!Base64",
        "!Join",
        "!Join sequence",
        "!Cidr",
        "!Ref",
        "!Sub",
        "!GetAtt",
        "!GetAZs",
        "!ImportValue sequence",
        "!Select sequence",
        "!Split sequence",
      },
      schemas = extended_schemas,
      hover = true,
      completion = true,
    },
  },
  setup = {
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
        end,
      },
    },
  },
}

return opts
