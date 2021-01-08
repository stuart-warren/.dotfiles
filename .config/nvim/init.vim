let need_to_install_plugins = 0
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    let need_to_install_plugins = 1
endif

function! SourceIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'tpope/vim-sensible'
Plug 'Vigemus/nvimux', { 'branch': 'master' }
Plug 'kassio/neoterm'
Plug 'janko/vim-test'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/syntastic'
Plug 'christoomey/vim-tmux-navigator'
Plug 'vim-airline/vim-airline', { 'tag': '*' }
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'markstory/vim-zoomwin'
" Asynchronous Lint Engine
Plug 'dense-analysis/ale'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'vimwiki/vimwiki'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'edkolev/tmuxline.vim'
Plug 'preservim/tagbar'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

if need_to_install_plugins == 1
    echo "Installing plugins..."
    silent! PlugInstall --sync
    silent! UpdateRemotePlugins
    echo "Done!"
    q
endif

if empty(glob('~/.vim/plugged/tmuxline.vim/tmux.conf')) && !empty($TMUX_PANE)
    echo "Setting up tmuxline"
    silent! Tmuxline airline
    silent! TmuxlineSnapshot "$HOME/.vim/plugged/tmuxline.vim/tmux.conf"
    echo "Done!"
endif

let mapleader = ","

filetype plugin indent on
set ttyfast
set termguicolors
set hidden
set laststatus=2 " Always display the statusline in all windows
set showtabline=2 " Always display the tabline, even if there is only one tab
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale#enabled = 1
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
set clipboard=unnamed
set clipboard+=unnamedplus
set relativenumber
set number
set mouse=a
set keymodel=startsel,stopsel
set updatetime=500

" No backups
set nobackup
set nowritebackup
set nowb
set noswapfile
" give us nice EOL (end of line) characters
set list
set listchars=tab:▸\ ,eol:¬
" Keep lots of history/undo
set undolevels=1000
" Files to ignore
" Python
set wildignore+=*.pyc,*.pyo,*/__pycache__/*
" Temp files
set wildignore+=*.swp,~*
" Archives
set wildignore+=*.zip,*.tar,*.gz
" code folding
set foldmethod=indent
set foldlevel=99
" Setup netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 0
let g:netrw_altv = 1
let g:netrw_winsize = 25

" Freed <C-l> in Netrw to allow tmux-navigation to work
nmap <leader><leader><leader><leader><leader><leader>l <Plug>NetrwRefresh

" reload config
nnoremap <Leader>vr :source $MYVIMRC<CR>

" map save file
" Note that remapping C-s requires flow control to be disabled
" (e.g. in .bashrc or .zshrc)
nnoremap <C-s> <esc>:w<CR>
inoremap <C-s> <esc>:w<CR>a
vnoremap <C-s> <Esc>:w<CR>

" copy, cut and paste
vmap <C-c> "+y
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <ESC>"+pa

" tags
map <leader>t :TagbarToggle<CR>

let g:LanguageClient_serverCommands = {
    \ 'python': ['pyls'],
    \ 'sh': ['bash-language-server', 'start'],
    \ 'typescript': ['javascript-typescript-stdio'],
    \ 'go': ['gopls'],
    \ }

let g:LanguageClient_rootMarkers = {
    \ 'python': ['setup.py'],
    \ 'typescript': ['tsconfig.json'],
    \ 'go': ['go.mod'],
    \ }
let g:LanguageClient_hoverPreview = "Auto"
let g:LanguageClient_useFloatingHover = 1
nmap <silent>K <Plug>(lcn-hover)

" pyenv virtualenv 3.8.6 neovim3
" pyenv activate neovim3
" pip install neovim
" pyenv which python
let g:python3_host_prog="$HOME/.pyenv/versions/neovim3/bin/python"

" Sends default register to terminal TTY using OSC 52 escape sequence
" https://github.com/leeren/dotfiles
let g:tty=system('readlink -f /proc/'.getpid().'/fd/0')
function! Osc52Yank()
    let buffer=system('base64 -w0', @0)
    let buffer=substitute(buffer, "\n$", "", "")
    let buffer='\e]52;c;'.buffer.'\x07'
    silent exe "!echo -ne ".shellescape(buffer).
        \ " > ".shellescape(g:tty)
endfunction
" Automatically call OSC52 function on yank to sync register with host clipboard
augroup Yank
  autocmd!
  autocmd TextYankPost * if v:event.operator ==# 'y' | call Osc52Yank() | endif
augroup END

if has('nvim')
  " disable line numbers in terminal
  autocmd TermOpen * setlocal nonumber norelativenumber
  " start in insert mode
  autocmd TermOpen term://* startinsert

  tnoremap <Esc> <C-\><C-n>
  tnoremap <Esc><Esc> <Esc>

  " " Terminal mode:
  " tnoremap <C-h> <c-\><c-n><c-w>h
  " tnoremap <C-j> <c-\><c-n><c-w>j
  " tnoremap <C-k> <c-\><c-n><c-w>k
  " tnoremap <C-l> <c-\><c-n><c-w>l
  " " Insert mode:
  " inoremap <C-h> <Esc><c-w>h
  " inoremap <C-j> <Esc><c-w>j
  " inoremap <C-k> <Esc><c-w>k
  " inoremap <C-l> <Esc><c-w>l
  " " Visual mode:
  " vnoremap <C-h> <Esc><c-w>h
  " vnoremap <C-j> <Esc><c-w>j
  " vnoremap <C-k> <Esc><c-w>k
  " vnoremap <C-l> <Esc><c-w>l
  " " Normal mode:
  " nnoremap <C-h> <c-w>h
  " nnoremap <C-j> <c-w>j
  " nnoremap <C-k> <c-w>k
  " nnoremap <C-l> <c-w>l

  set shell=/bin/zsh

  let $VISUAL      = 'nvr -cc split --remote-wait +"setlocal bufhidden=delete"'
  let $GIT_EDITOR  = 'nvr -cc split --remote-wait +"setlocal bufhidden=delete"'
  let $EDITOR      = 'nvr +"setlocal bufhidden=delete"'
endif

autocmd FileType typescript setlocal formatprg=prettier\ --parser\ typescript

autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype go setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype yaml setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
" ts - show existing tab with 4 spaces width
" sw - when indenting with '>', use 4 spaces width
" sts - control <tab> and <bs> keys to match tabstop

" Control all other files
set shiftwidth=4

" ALE Configuration
let g:ale_fixers = {
\    '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'json': ['prettier'],
\   'python': ['black', 'isort'],
\   'typescript': ['tsserver', 'tslint'],
\   'yaml': ['prettier'],
\}
let g:ale_linters = {
\   'json': ['prettier'],
\   'python': ['flake8', 'mypy', 'pylint', 'bandit'],
\   'typescript': ['prettier'],
\   'yaml': ['prettier'],
\}
let g:ale_fix_on_save = 1
let g:ale_sign_column_always = 1
let g:ale_hover_to_preview = 1
let g:go_fmt_command = "goimports"    " Run goimports along gofmt on each save
let g:go_auto_type_info = 1           " Automatically get signature/type info for object under cursor



noremap <C-a>z :ZoomToggle<CR>
noremap <leader>_ :split $PWD<CR>
noremap <leader><bar> :vsplit $PWD<CR>

" vim-test
let test#strategy = {
  \ 'nearest': 'neovim',
  \ 'file':    'dispatch',
  \ 'suite':   'basic',
\}
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>

let g:tagbar_type_go = {
	\ 'ctagstype' : 'go',
	\ 'kinds'     : [
		\ 'p:package',
		\ 'i:imports:1',
		\ 'c:constants',
		\ 'v:variables',
		\ 't:types',
		\ 'n:interfaces',
		\ 'w:fields',
		\ 'e:embedded',
		\ 'm:methods',
		\ 'r:constructor',
		\ 'f:functions'
	\ ],
	\ 'sro' : '.',
	\ 'kind2scope' : {
		\ 't' : 'ctype',
		\ 'n' : 'ntype'
	\ },
	\ 'scope2kind' : {
		\ 'ctype' : 't',
		\ 'ntype' : 'n'
	\ },
	\ 'ctagsbin'  : 'gotags',
	\ 'ctagsargs' : '-sort -silent'
\ }

" vimwiki with markdown support
let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}

map <leader>md :MarkdownPreview<CR>
au FileType markdown setl shell=bash\ -i

iab <expr> dts strftime('%Y-%m-%d')

let g:UltiSnipsSnippetDirectories=["UltiSnips"]
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsEditSplit="vertical"

" disable autoindent when pasting text
" source: https://coderwall.com/p/if9mda/automatically-set-paste-mode-in-vim-when-pasting-in-insert-mode
function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

call SourceIfExists("$HOME/.vimrc.local")
