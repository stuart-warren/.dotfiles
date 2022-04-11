local status_ok, lspcontainers = pcall(require, "lspcontainers")
if not status_ok then
	return
end

local util = require("lspconfig/util")
local path = util.path
local exepath = vim.fn.exepath

local function get_python_path()
  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    return path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
  end

  -- Fallback to system Python.
  return exepath('python3') or exepath('python') or 'python'
end

-- use https://github.com/alefpereira/pyenv-pyright with pyenv
local opts = {
    before_init = function(params)
      params.processId = vim.NIL
    end,
    cmd = lspcontainers.command("pyright"),
    filetypes = { "python" },
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          useLibraryCodeForTypes = true,
        },
        typeCheckingMode = "strict",
      },
    },
    single_file_support = true,
}

return opts

