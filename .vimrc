" Basic vim configuration
set nocompatible              " Use Vim settings, rather than Vi settings
filetype plugin indent on     " Enable file type detection and do language-dependent indenting
syntax enable                 " Enable syntax highlighting
set background=dark           " Use colors that look good on a dark background

" Set color scheme
if has('gui_running') || &t_Co >= 256
    colorscheme desert
endif

" Basic settings
set encoding=utf-8            " Set default encoding to UTF-8
set number                    " Show line numbers
set relativenumber            " Show relative line numbers
set ruler                     " Show cursor position
set cursorline                " Highlight current line
set wildmenu                  " Visual autocomplete for command menu
set lazyredraw                " Redraw only when we need to
set showmatch                 " Highlight matching [{()}]
set incsearch                 " Search as characters are entered
set hlsearch                  " Highlight matches
set ignorecase                " Ignore case when searching
set smartcase                 " When searching try to be smart about cases

" Indentation settings
set expandtab                 " Use spaces instead of tabs
set smarttab                  " Be smart when using tabs
set shiftwidth=4              " One tab == four spaces
set tabstop=4                 " One tab == four spaces
set autoindent                " Auto indent
set smartindent               " Smart indent

" Enable mouse support
set mouse=a                   " Enable mouse for all modes

" Disable backup and swap files
set nobackup
set nowritebackup
set noswapfile

" Show invisible characters
set listchars=tab:’\ ,eol:¬,trail:Å,extends:o,precedes:n
set showbreak=ª

" Enable folding
set foldmethod=indent
set foldlevelstart=10         " Open most folds by default
set foldnestmax=10            " 10 nested fold max

" Key mappings
let mapleader = ","           " Set leader key to comma

" Toggle paste mode
set pastetoggle=<F2>

" Save with Ctrl+S
noremap <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR>

" Clear search highlights
nnoremap <leader><space> :nohlsearch<CR>

" Toggle relative numbers
nnoremap <leader>n :set relativenumber!<CR>

" Toggle showing invisible characters
nnoremap <leader>l :set list!<CR>

" Movement in insert mode
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

" Better indentation
vnoremap < <gv
vnoremap > >gv

" Split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Open splits in a more natural way
set splitbelow
set splitright

" Status line
set laststatus=2              " Always show the status line
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ [BUFFER=%n]\ %{strftime('%c')}

" Auto-reload changed files
set autoread
au FocusGained,BufEnter * checktime

" Persistent undo
if has('persistent_undo')
    set undodir=~/.vim/undodir
    set undofile
    if !isdirectory(&undodir)
        call mkdir(&undodir, 'p')
    endif
endif

" Platform specific settings
if has('macunix')
    " macOS specific settings
    set clipboard=unnamed      " Use system clipboard
elseif has('unix')
    " Linux specific settings
    set clipboard=unnamedplus  " Use system clipboard
endif