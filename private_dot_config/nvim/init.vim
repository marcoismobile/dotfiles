" Autoinstall vim-plug
let plug_path = (has('nvim') ? stdpath('data') . '/site' : '~/.vim') . '/autoload/plug.vim'
let plug_install = 0
if empty(glob(plug_path))
  silent execute '!curl -fLo '.plug_path.' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  execute 'source ' . fnameescape(plug_path)
  let plug_install = 1
endif
unlet plug_path

let lsp_enabled = has('nvim') && executable('python3')

call plug#begin()
" Theme
Plug 'nanotech/jellybeans.vim'
" Lightline
Plug 'itchyny/lightline.vim'
" CtrlP (File browser)
Plug 'ctrlpvim/ctrlp.vim'
" Fugitive (Git functionality)
Plug 'tpope/vim-fugitive'
" GitGutter (Git in gutter)
Plug 'airblade/vim-gitgutter'
" ALE (Asynchronous Lint Engine)
Plug 'dense-analysis/ale'
" GPG (GPG encrypt/decrypt)
Plug 'jamessan/vim-gnupg'
" NERD Commenter
Plug 'preservim/nerdcommenter'

if lsp_enabled
  " LSP
  Plug 'neovim/nvim-lspconfig'
  " COQ
  Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
  Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
endif

call plug#end()

if plug_install
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
unlet plug_install

" Not compatible with the old-fashion vi mode
set nocompatible
" Encoding utf-8
set encoding=utf-8
" Colors
set background=dark
set guicursor=
" No backup or swap, autoread file when external edited
set nobackup nowritebackup noswapfile autoread
" Search
set hlsearch incsearch ignorecase smartcase
" Show cursor position in status bar
set ruler
" Show absolute line number of the current line
set number
" Disable unloading of buffers
set hidden
" Set shorter delays
set timeoutlen=1000 ttimeoutlen=10 updatetime=100
" Remove current mode status
set noshowmode
" Disable code folding
set nofoldenable
" Set maximum number of tabs
set tabpagemax=50
" Scroll the window so we can always see 10 lines around the cursor
set scrolloff=10
" Turn off alt shortcuts
set winaltkeys=no
" Disable annoying sound on errors
set noerrorbells
set novisualbell
set vb t_vb=
" Set ident defaults
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab
" Show special chars
set list
set listchars=eol:⏎,tab:␉·,trail:␠,nbsp:⎵
" Syntax highlighing
syntax on
filetype plugin indent on

" Netrw
let g:netrw_banner = 0
let g:netrw_winsize = 25
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_keepdir = 0
nnoremap <Leader>f :Lexplore<CR>

" Todo command
command! Todo noautocmd vimgrep /TODO\|FIXME/j ** | cw
" Create readable JSON view
command! ShowJSON %!python -m json.tool

" Shortcuts
inoremap <script> <silent> <buffer> time<Tab> <C-R>=strftime("%H:%M")<CR>
inoremap <script> <silent> <buffer> date<Tab> <C-R>=strftime("%Y-%m-%d")<CR>
noremap <C-w>- :split<CR>
noremap <C-w>\ :vsplit<CR>

" Theme
let g:jellybeans_use_term_italics = 1
let g:jellybeans_overrides = {
    \ 'background': { 'guibg': '#000000' }
\ }
silent! colorscheme jellybeans

" Lightline
let g:lightline = {
    \ 'colorscheme': '16color',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
    \ },
    \ 'component_function': {
    \   'gitbranch': 'FugitiveHead'
    \ },
\ }

" ALE
let g:ale_virtualtext_cursor = 'disabled'
let g:ale_linters_explicit = 1
let g:ale_linters = {
    \ 'puppet': ['puppetlint'],
    \ 'python': ['flake8'],
    \ 'yaml': ['yamllint'],
\ }

" CtrlP
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_show_hidden = 1
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_max_files = 500
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn)$',
    \ 'file': '\v\.(pyc|swp|vim)$',
\ }

" Nvim-lspconfig and coq_nvim
if lsp_enabled
lua <<EOF

-- Mappings
local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Additional mapping after LSP server is attached
local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Load LSP servers
local servers = {
  'bashls',
  'dockerls',
  'pyright',
  'yamlls',
}
local lsp = require('lspconfig')
local coq = require('coq')
for _, server in pairs(servers) do
  lsp[server].setup(coq.lsp_ensure_capabilities({
    on_attach = on_attach,
  }))
end
EOF

" Start COQ
autocmd VimEnter * COQnow --shut-up
endif
unlet lsp_enabled
