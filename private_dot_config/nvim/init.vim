" Autoinstall vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
" Jellybeans Theme
Plug 'nanotech/jellybeans.vim'
" Airline
Plug 'vim-airline/vim-airline'
" Airline Themes
Plug 'vim-airline/vim-airline-themes'
" CtrlP (File browser)
Plug 'ctrlpvim/ctrlp.vim'
" Fugitive (Git)
Plug 'tpope/vim-fugitive'
" GitGutter (Git diff)
Plug 'airblade/vim-gitgutter'
" Syntastic (Syntax checking)
Plug 'vim-syntastic/syntastic'
" GPG (GPG encrypt/decrypt)
Plug 'jamessan/vim-gnupg'
" COQ
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
call plug#end()

" not compatible with the old-fashion vi mode
set nocompatible
" encoding utf-8
set encoding=utf-8
" colors
set termguicolors
set guicursor=
" no backup or swap, autoread file when external edited
set nobackup nowritebackup noswapfile autoread
" search
set hlsearch incsearch ignorecase smartcase
" show cursor position in status bar
set ruler
" show absolute line number of the current line
set number
" disable unloading of buffers
set hidden
" set shorter delays
set timeoutlen=1000 ttimeoutlen=10 updatetime=100
" remove current mode status
set noshowmode
" disable code folding
set nofoldenable
" set maximum number of tabs
set tabpagemax=50
" scroll the window so we can always see 10 lines around the cursor
set scrolloff=10
" turn off alt shortcuts
set winaltkeys=no
" disable annoying sound on errors
set noerrorbells
set novisualbell
set vb t_vb=
" set ident defaults
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
" show special chars
set list
set listchars=eol:⏎,tab:␉·,trail:␠,nbsp:⎵

syntax on
filetype plugin indent on

" todo command
command! Todo noautocmd vimgrep /TODO\|FIXME/j ** | cw
" create readable JSON view
command! ShowJSON %!python -m json.tool

" shortcuts
inoremap <script> <silent> <buffer> time<Tab> <C-R>=strftime("%H:%M")<CR>
inoremap <script> <silent> <buffer> date<Tab> <C-R>=strftime("%Y-%m-%d")<CR>
noremap <C-w>- :split<CR>
noremap <C-w>\ :vsplit<CR>

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_puppet_checkers=['puppetlint']
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_yaml_checkers = ['yamllint']

" CtrlP
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_show_hidden = 1
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_max_files = 500
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn)$',
    \ 'file': '\v\.(pyc|swp|vim)$',
    \ }

" Airline
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#buffer_nr_show=1
let g:airline#extensions#whitespace#enabled=0

" Theme
silent! colorscheme jellybeans
silent! let g:airline_theme='minimalist'
highlight Comment ctermfg=darkgray cterm=italic

" COQ
autocmd VimEnter * COQnow --shut-up
