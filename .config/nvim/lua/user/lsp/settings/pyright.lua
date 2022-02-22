
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

local opts = {
    cmd = { "pyright-langserver", "--stdio" },
    
    filetypes = { "python" },
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          useLibraryCodeForTypes = true,
        },
        pythonPath = get_python_path(),
        venvPath = path.join(vim.env.HOME, ".pyenv", "versions"),
      },
    },
    single_file_support = true,
}

return opts

