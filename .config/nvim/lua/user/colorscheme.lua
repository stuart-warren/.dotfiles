vim.cmd [[
try
  autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
  colorscheme darkplus
  autocmd BufEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  autocmd InsertLeave * match ExtraWhitespace /\s\+$/
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]]
