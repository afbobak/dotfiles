call pathogen#infect()
set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim
set nocompatible

" Fix background erase in tmux
set t_ut=
" Smooth redraws
set ttyfast
" Faster escape sequences
set ttimeoutlen=25
"augroup FastEscape
"  autocmd!
"  au InsertEnter * set timeoutlen=0
"  au InsertLeave * set timeoutlen=10
"augroup end

" Update things faster (e.g. GitGutter)
set updatetime=1000

" Leave --insert-- to Airline
set noshowmode

" Sound off
set noerrorbells

" Store swap files in fixed location, not current directory.
set dir=~/.cache/vim/swap//,.
set undodir=~/.cache/vim/undo//,.
set backupdir=~/.cache/vim/backup//,.
" Do not create backup and swap files
set nobackup
set nowritebackup
set noswapfile

" Indentation
set smartindent
set shiftwidth=2 softtabstop=2 tabstop=2 expandtab

" Show line numbers
set number

" Put buffers with changes in the background without warning
set hidden
set history=100

" Enable mouse
if has('mouse')
  set mouse=nv
endif

" Share OS clipboard if not running under tmux
if $TMUX == ''
  set clipboard=unnamed
endif

" Auto append suffixes
set suffixesadd+=.js

" Per project .vimrc
set exrc
set encoding=utf-8

" Enable syntax highlighting
syntax on
" Color
if $SSH_CONNECTION == ''
	set background=light
else
	set background=dark
endif
colorscheme solarized
highlight CursorLineNr ctermfg=yellow
if $USER == 'root'
	highlight Normal ctermbg=lightred
endif

" Print margin
if v:version >= 703
  set colorcolumn=80
endif
" Highlight text exceeding the print margin
highlight OverLength ctermbg=red ctermfg=white
match OverLength /\%80v.\+/

" Turn off line wrapping
set nowrap

" Highlight active line
set cursorline

" Text-mate style display of invisible characters (tab/newline)
set listchars=tab:>\ ,eol:¬
set list
highlight NonText ctermfg=238

" Set the leader key to ,
let mapleader = ","
" Toggle Nerd Tree
noremap <Leader>n :NERDTreeToggle<CR>
" Reveal in Nerd Tree
noremap <Leader>. :NERDTreeFind<CR>
" Find
noremap <Leader>f :find
" TODOs
noremap <Leader>t :vimgrep /FIXME\\|TODO/g
" Copy / Nocopy
noremap <Leader>c :set nolist<CR>:set nonumber<CR>:set colorcolumn=<CR>:GitGutterDisable<CR>:SyntasticToggleMode<CR>
noremap <Leader>C :set list<CR>:set number<CR>:set colorcolumn=80<CR>:GitGutterEnable<CR>:SyntasticToggleMode<CR>
" Paste / Nopaste
noremap <Leader>p :set paste<CR>
noremap <Leader>P :set nopaste<CR>
" Tabularize on = and :
vnoremap <Leader>= :Tabularize /=<CR>
vnoremap <Leader>: :Tabularize /:<CR>
" Expand %% to directory of current buffer
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" File types
autocmd BufEnter *.json set filetype=javascript
" Do not keep fugitive Git browsing buffers
autocmd BufReadPost fugitive://* set bufhidden=delete

" Diff current buffer with original file
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis

" Flavored Markdown by default
augroup markdown
  au!
  au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
augroup END

" Customize Powerline
let g:Powerline_symbols = "fancy"
" call Pl#Theme#RemoveSegment('fileformat')
" call Pl#Theme#RemoveSegment('lineinfo')
" Snipmate
let g:snippets_dir="~/.vim/snippets"

" Syntastic (jshint is a symlink to autolint)
let g:syntastic_javascript_checkers = ['jslint']
let g:syntastic_check_on_open       = 1
let g:syntastic_error_symbol        = 'X'
let g:syntastic_warning_symbol      = '!'
let g:syntastic_loc_list_height     = 5
highlight SyntasticErrorSign ctermfg   = red
highlight SyntasticWarningSign ctermfg = yellow

" JSON
let g:vim_json_syntax_conceal = 0

" Show npm version for package name under cursor
map <Leader>v yi":!npm show <C-r>0 version<CR>
