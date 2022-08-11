set exrc
set relativenumber
set nu
set nohlsearch
set hidden
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nowrap
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=8
set noshowmode
set completeopt=menuone,noinsert,noselect
set signcolumn=yes
set path+=**

set colorcolumn=80
set signcolumn=yes

set cmdheight=2

let g:python3_host_prog = $HOME .. '\Anaconda3\python'
let g:ultisnips_python_style = 'numpy' " Types of doctrings used for python
let g:sneak#label = 1
let g:SuperTabDefaultCompletionType = "<c-n>"

call plug#begin($HOME .. '\AppData\Local\nvim\autoload\plugged')
" Define new motions
Plug 'tpope/vim-surround'                        " ys | cs | ds
Plug 'tpope/vim-commentary'                      " gc
Plug 'vim-scripts/ReplaceWithRegister'           " gr
Plug 'christoomey/vim-titlecase'                 " gz
Plug 'christoomey/vim-sort-motion'               " gs
Plug 'christoomey/vim-system-copy'               " cp | cv
Plug 'phaazon/hop.nvim'                          " s | S
" To make new motions repeatable
Plug 'tpope/vim-repeat'
" Highlights first unique character of each word 
Plug 'unblevable/quick-scope' 

" Language Server Protocol (LSP)
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'thomasfaingnaert/vim-lsp-snippets'
Plug 'thomasfaingnaert/vim-lsp-ultisnips'

" Telescope dependencies
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Background theme
Plug 'gruvbox-community/gruvbox'

Plug 'nvim-treesitter/nvim-treesitter'

Plug 'untitled-ai/jupyter_ascending.vim'

Plug 'metakirby5/codi.vim'

Plug 'lervag/vimtex'

Plug 'ThePrimeagen/vim-be-good' " Game

Plug 'ervandew/supertab'
call plug#end()


let mapleader = " "

nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>p "+p
nnoremap <leader>P "+P

" New lines
nnoremap go m`o<ESC>``
nnoremap gO m`O<ESC>``
nnoremap g<CR> i<CR><ESC>

" File Explorer
nnoremap <leader>e <cmd>Explore<cr>
nnoremap <leader>ve <cmd>Vexplore!<cr>

" Hop setup
lua require('hop').setup()
nmap s <cmd>HopChar2AC<CR>
nmap S <cmd>HopChar2BC<CR>
vmap s <cmd>HopChar2AC<CR>
vmap S <cmd>HopChar2BC<CR>

" Color theme
colorscheme gruvbox
highlight Normal guibg=none

" Telescope
" nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>
nnoremap <leader>f <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>g <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>b <cmd>lua require('telescope.builtin').buffers()<cr>
" nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
"
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif


" LSP config
if executable('pyright-langserver')
    augroup vim_lsp_py
        autocmd!
        " :LspInstallServer pyright-langserver
        " pip install pyright
        au User lsp_setup call lsp#register_server({
            \ 'name': 'pyright-langserver',
            \ 'cmd': {server_info->['pyright-langserver']},
            \ 'whitelist': ['py'],
            \ })
        autocmd FileType py setlocal omnifunc=lsp#complete
        au User lsp_setup call lsp#register_server({
            \ 'name': 'texlab',
            \ 'cmd': {server_info->['texlab']},
            \ 'whitelist': ['tex'],
            \ })
        autocmd FileType tex setlocal omnifunc=lsp#complete
    augroup end
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    " nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    " nmap <buffer> K <plug>(lsp-hover)
    " nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    " nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
    
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

