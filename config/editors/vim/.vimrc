set nocompatible

" ================ General Config ====================

set number
set backspace=indent,eol,start
set history=1000
set showcmd
set showmode
set gcr=a:blinkon0
set visualbell
set autoread
set ruler

set hidden

syntax on

let mapleader=","

" ================ Turn Off Swap Files ==============

set noswapfile
set nobackup
set nowb

" ================ Persistent Undo ==================
if has('persistent_undo') && !isdirectory(expand('~').'/vim/backups')
  silent !mkdir ~/vim/backups > /dev/null 2>&1
  set undodir=~/vim/backups
  set undofile
endif

" ================ Indentation ======================

set autoindent
set smartindent
set smarttab
set shiftwidth=4
set softtabstop=4
set tabstop=4

nnoremap p p=`]<C-o>
nnoremap P P=`]<C-o>

filetype plugin on
filetype indent on

set nowrap
set linebreak

" ================ Folds ============================

set foldmethod=indent
set foldnestmax=3
set nofoldenable

" ================ Completion =======================

set wildmode=list:longest
set wildmenu
set wildignore=*.o,*.obj,*~
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif

" ================ Scrolling ========================

set scrolloff=8
set sidescrolloff=15
set sidescroll=1

" ================ Search ===========================

set incsearch
set hlsearch
set ignorecase
set smartcase
