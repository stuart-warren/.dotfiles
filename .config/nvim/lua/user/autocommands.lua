vim.cmd [[
  augroup _general_settings
    autocmd!
    autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR> 
    autocmd TextYankPost * silent!lua require('vim.highlight').on_yank({higroup = 'Visual', timeout = 200}) 
    autocmd BufWinEnter * :set formatoptions-=cro
    autocmd FileType qf set nobuflisted
  augroup end

  if has('nvim')
    let $GIT_EDITOR = 'nvr -cc split --remote-wait'
  endif

  augroup _git
    autocmd!
    autocmd FileType gitcommit setlocal wrap
    autocmd FileType gitcommit setlocal spell
    autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete
  augroup end

  augroup _markdown
    autocmd!
    autocmd FileType markdown setlocal wrap
    autocmd FileType markdown setlocal spell
  augroup end

  augroup _terminal
    autocmd!
    " autocmd TermOpen * execute "set termwinsize=0x" . (winwidth("%")-6)
	  " autocmd VimResized * execute "set termwinsize=0x" . (winwidth("%")-6)
    autocmd TermOpen * setlocal nonumber
    autocmd TermOpen * exec "normal! i"
    autocmd BufEnter term://* startinsert
  augroup end

  augroup _lsp
    autocmd!
    autocmd BufWritePre *.go lua vim.lsp.buf.formatting_seq_sync()
    autocmd BufWritePre *.lua lua vim.lsp.buf.formatting_seq_sync()
  augroup end


]]

-- augroup _auto_resize
--   autocmd!
--   autocmd VimResized * tabdo wincmd = 
-- augroup end
