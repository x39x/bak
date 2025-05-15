syntax on
filetype indent plugin on
set ttimeout ttyfast ttimeoutlen=1 "esc delay
set nocompatible  " no 'VI'
set noerrorbells
set nobackup
set noswapfile
set autoread
set number
set cursorline
set laststatus=2
set nowrap
set ruler
set list
set listchars=tab:<_,trail:~
set fillchars=eob:\  
set scrolloff=5
set splitright
set splitbelow
set foldmethod=manual
set showmatch
set mouse=a
set autoindent
set smartindent
set copyindent
set expandtab
set tabstop=4
set shiftwidth=4
set hlsearch
set incsearch
set ignorecase
set smartcase
set wildmode=list:longest,full
"dark: habamax koehler retrobox, light: delek
set bg=light
colorscheme delek
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
let mapleader = "\<Space>"

noremap J j
noremap \| J
noremap H ^
noremap L $
noremap q %
noremap % q
nnoremap ;j :let @/ = '<c-r><c-w>' \| set hls<CR>
nnoremap ;k :nohl<CR>
nnoremap gcc :norm I//<CR>
vnoremap L $h
vnoremap gc :norm I//<CR>
inoremap jk <ESC>
inoremap { {<CR>}<Esc>O

finish
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"VIM-PLUG  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin()
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tomtom/tcomment_vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
call plug#end()

let g:startify_files_number = 5
let g:startify_session_autoload = 1
let g:startify_custom_header = [
                        \'',
                        \'',
                        \'        ⢀⣴⡾⠃⠄⠄⠄⠄⠄⠈⠺⠟⠛⠛⠛⠛⠻⢿⣿⣿⣿⣿⣶⣤⡀  ',
                        \'      ⢀⣴⣿⡿⠁⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⣸⣿⣿⣿⣿⣿⣿⣿⣷ ',
                        \'     ⣴⣿⡿⡟⡼⢹⣷⢲⡶⣖⣾⣶⢄⠄⠄⠄⠄⠄⢀⣼⣿⢿⣿⣿⣿⣿⣿⣿⣿ ',
                        \'    ⣾⣿⡟⣾⡸⢠⡿⢳⡿⠍⣼⣿⢏⣿⣷⢄⡀⠄⢠⣾⢻⣿⣸⣿⣿⣿⣿⣿⣿⣿ ',
                        \'  ⣡⣿⣿⡟⡼⡁⠁⣰⠂⡾⠉⢨⣿⠃⣿⡿⠍⣾⣟⢤⣿⢇⣿⢇⣿⣿⢿⣿⣿⣿⣿⣿ ',
                        \' ⣱⣿⣿⡟⡐⣰⣧⡷⣿⣴⣧⣤⣼⣯⢸⡿⠁⣰⠟⢀⣼⠏⣲⠏⢸⣿⡟⣿⣿⣿⣿⣿⣿ ',
                        \' ⣿⣿⡟⠁⠄⠟⣁⠄⢡⣿⣿⣿⣿⣿⣿⣦⣼⢟⢀⡼⠃⡹⠃⡀⢸⡿⢸⣿⣿⣿⣿⣿⡟ ',
                        \' ⣿⣿⠃⠄⢀⣾⠋⠓⢰⣿⣿⣿⣿⣿⣿⠿⣿⣿⣾⣅⢔⣕⡇⡇⡼⢁⣿⣿⣿⣿⣿⣿⢣ ',
                        \' ⣿⡟⠄⠄⣾⣇⠷⣢⣿⣿⣿⣿⣿⣿⣿⣭⣀⡈⠙⢿⣿⣿⡇⡧⢁⣾⣿⣿⣿⣿⣿⢏⣾ ',
                        \' ⣿⡇⠄⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⢻⠇⠄⠄⢿⣿⡇⢡⣾⣿⣿⣿⣿⣿⣏⣼⣿ ',
                        \' ⣿⣷⢰⣿⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⢰⣧⣀⡄⢀⠘⡿⣰⣿⣿⣿⣿⣿⣿⠟⣼⣿⣿ ',
                        \' ⢹⣿⢸⣿⣿⠟⠻⢿⣿⣿⣿⣿⣿⣿⣿⣶⣭⣉⣤⣿⢈⣼⣿⣿⣿⣿⣿⣿⠏⣾⣹⣿⣿ ',
                        \' ⢸⠇⡜⣿⡟⠄⠄⠄⠈⠙⣿⣿⣿⣿⣿⣿⣿⣿⠟⣱⣻⣿⣿⣿⣿⣿⠟⠁⢳⠃⣿⣿⣿ ',
                        \'  ⣰⡗⠹⣿⣄⠄⠄⠄⢀⣿⣿⣿⣿⣿⣿⠟⣅⣥⣿⣿⣿⣿⠿⠋  ⣾⡌⢠⣿⡿⠃ ',
                        \' ⠜⠋⢠⣷⢻⣿⣿⣶⣾⣿⣿⣿⣿⠿⣛⣥⣾⣿⠿⠟⠛⠉            ',
                        \'',
                        \'',
                        \]
let g:NERDTreeMapChangeRoot="l"
let g:NERDTreeMapUpdir="h"
nnoremap  <Leader>ff :Files<CR>
nnoremap  <Leader>fh :History<CR>
nnoremap  <Leader>fl :Rg<CR>
nnoremap  <Leader>fw :Lines<CR>
nnoremap  <Leader>fs :Colors<CR>
nnoremap  <Leader>fm :Marks<CR>
nnoremap  <Leader>j :Buffers<CR>
nnoremap <leader>n :NERDTree<CR>
