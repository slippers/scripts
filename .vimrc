" https://realpython.com/blog/python/vim-and-python-a-match-made-in-heaven/

set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required!
Plugin 'VundleVim/Vundle.vim'

Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'

Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

Plugin 'vim-flake8'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'tmhedberg/SimpylFold'

" http://valloric.github.io/YouCompleteMe/#ubuntu-linux-x64
" must compile this for the server to work
Plugin 'Valloric/YouCompleteMe'

Plugin 'scrooloose/syntastic'
Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'

Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'

Plugin 'kien/ctrlp.vim'

" http://vimcasts.org/episodes/fugitive-vim---a-complement-to-command-line-git/
Plugin 'tpope/vim-fugitive'

Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

"To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

nnoremap <C-n> :call NumberToggle()<cr>
function! NumberToggle()
    if(&relativenumber == 1)
        set norelativenumber
    else
        set relativenumber
    endif
endfunc


map <F3> : call CompileGcc()<CR>
func! CompileGcc()
  exec "w"
  exec "!gcc % -o %<"
endfunc

map <F4> :call CompileRunGcc()<CR>
func! CompileRunGcc()
  exec "w"
  exec "!gcc % -o %<"
  exec "! ./%<"
endfunc

map <F6> :execute "vimgrep /" . expand("<cword>") . "/j **" <Bar> cw<CR>

set backspace=indent,eol,start  "allow backspacing over everything in insert mode

set history=50                  "keep 50 lines of command line history

set ruler                       "show the cursor position all the time

set showcmd                     "display incomplete commands

set incsearch                   "do incremental searching

set nu                          "show line numbers

set expandtab                   "use spaces instead of tabs

set tabstop=4                   "insert 4 spaces whenever the tab key is pressed

set shiftwidth=4                "set indentation to 4 spaces

set hlsearch                    "highlight search terms

set ic                          "Ignore Case during searches

set autoindent                  "start new line at the same indentation level

syntax enable                   "syntax highlighting

set cmdheight=1                 "The commandbar height

set showmatch                   "Show matching bracets when text indicator is over them

set nobackup                    " do not keep backup files, it's 70's style cluttering

set noswapfile                  " do not write annoying intermediate swap files,
                                " who did ever restore from swap files anyway?
                                " https://github.com/nvie/vimrc/blob/master/vimrc#L141

set ttimeoutlen=50              "Solves: there is a pause when leaving insert mode

set splitbelow                  " Horizontal splits open below current file

set splitright                  " Vertical splits open to the right of the current file

set wildmode=longest,list       " Pressing <Tab> shows command suggestions similar to pressing <Tab>

set encoding=utf-8

syntax on

au BufNewFile,BufRead *.py:
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix

au BufNewFile,BufRead *.js, *.html, *.css:
    \ set tabstop=2
    \ set softtabstop=2
    \ set shiftwidth=2

" Enable folding with the spacebar
nnoremap <space> za

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>


"define BadWhitespace before using in a match
highlight BadWhitespace ctermbg=red guibg=darkred
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/


" YouCompleteMe autoclose
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

"python with virtualenv support
python3 << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    if os.path.exists(activate_this):
        execfile(activate_this, dict(__file__=activate_this))
EOF


let python_highlight_all=1

if has('gui_running')
    set background=dark
    colorscheme solarized
else
    colorscheme zenburn
endif

call togglebg#map("<F5>")


let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

