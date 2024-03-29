"     	       _
"       __   _(_)_ __ ___  _ __ ___
"       \ \ / / | '_ ` _ \| '__/ __|
"        \ V /| | | | | | | | | (__
"         \_/ |_|_| |_| |_|_|  \___|
"

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim
"
"
if has("syntax")
  syntax on
endif

" In case automatic PlugInstall is wanted. These commands need to placed
" before plug#begin
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Write PlugInstall when in command mode to install plugins
call plug#begin('~/.vim/plugged')
"   Plug 'scrooloose/nerdtree'
"   Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'flazz/vim-colorschemes'
    Plug 'junegunn/goyo.vim'
    Plug 'chrisbra/csv.vim'
call plug#end()

:filetype plugin on

" Some colorschemes. Note to self: many of the old colorschemes are broken
colorscheme ps_color
"
" This one is nice :)
" colorscheme 1989
"
" This is good too
" colorscheme VIvid
" Pretty calm one
" colorscheme inori
" colorscheme astronaut


" Splits open at the right and bottom
set splitbelow splitright

" Autocompletion on command mode
" set wildmode=longest,list,full

" Setting for indents that consist of 4 space characters but are entered with the tab key:
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
" if has("autocmd")
"   au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
"if has("autocmd")
"  filetype plugin indent on
"endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
"set showcmd		" Show (partial) command in status line.
"set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
"set smartcase		" Do smart case matching
"set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
"set hidden		" Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes)

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

set wrap

" Don't show matching brackets.
let g:loaded_matchparen=1

" Relative numbering
set relativenumber
" set number

" To add column to the beginging
" set foldcolumn=3

" Automatically deletes all trailing whitespaces on save.
autocmd BufWritePre * %s/\s\+$//e

" mapleader pointed to ,
let mapleader=","

" Use ,cc to comment out and ,cu to uncomment Python
augroup commentgroup
    autocmd FileType sh,ruby,python    let b:comment_leader = '# '
    noremap <silent> <leader>cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
    noremap <silent> <leader>cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>
augroup END

" Mappings to comment out and to uncomment XML/HTML
map <leader>d :s/^\(.*\)$/<!-- \1 -->/<CR>:nohlsearch<CR>
map <leader>f :s/^\([/(]\*\\|<!--\) \(.*\) \(\*[/)]\\|-->\)$/\2/<CR>
" Convert each name_like_this to NameLikeThis in current line.

let g:python_highlight_all = 1

" 80 character line highlight
" highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" match OverLength /\%81v.\+/

" normal 80 character line:
:set colorcolumn=88
highlight ColorColumn ctermbg=8

syntax on

" Write ','+'z' to add brackets
:nnoremap <leader>z viw<esc>a)<esc>hbi(<esc>lel
:nnoremap <leader>x viw<esc>a"<esc>hbi"<esc>lel
:nnoremap <leader>q viw<esc>a'<esc>hbi'<esc>lel
:nnoremap <leader>v viw<esc>a]<esc>hbi[<esc>lel
:nnoremap <leader>< viw<esc>a}<esc>hbi{<esc>lel

" Write empty brackets
:nnoremap <leader>a a()<esc><right>
:nnoremap <leader>w a[]<esc><right>
:nnoremap <leader>e a{}<esc><right>

" Quicker way to replace stuff, so just press 'S'
:nnoremap S :%s//g<Left><Left>

" Quick Goyo commands
:nnoremap goo :Goyo
:nnoremap goi :Goyo!

" jk remapped to behave as ESC
:inoremap jk <esc>

" Change name_like_this to NameLikeThis
:nnoremap <leader>o viw::s#\(\%(\<\l\+\)\%(_\)\@=\)\\|_\(\l\)#\u\1\2#g

" Highlight a column in csv text.
" :Csv 1    " highlight first column
" :Csv 12   " highlight twelfth column
" :Csv 0    " switch off highlight
function! CSVH(colnr)
  if a:colnr > 1
    let n = a:colnr - 1
    execute 'match Keyword /^\([^,]*,\)\{'.n.'}\zs[^,]*/'
    execute 'normal! 0'.n.'f,'
  elseif a:colnr == 1
    match Keyword /^[^,]*/
    normal! 0
  else
    match
  endif
endfunction
command! -nargs=1 Csv :call CSVH(<args>)
