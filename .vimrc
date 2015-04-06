set nocompatible
let mapleader = ","
"
" Bundles
"
" https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')

" Ack
" :AckFromSearch - ack from current search 
" v - open result in vertical split
Plug 'mileszs/ack.vim'

" Adds :Qargs and :Qdo command to act on matches in quickfix list (used by :Ack)
Plug 'henrik/vim-qargs'

let g:ack_default_options = " -s -H --nocolor --nogroup --column --smart-case --follow"
let g:ack_wildignore = 0
let g:ack_mappings = { "o": "<CR>zz" }
let g:ack_mappings = { "<C-V>": "<C-W><CR><C-W>H<C-W>b<C-W>J<C-W>t" }
let g:ackhighlight = 1 
nnoremap <leader>a :Ack!<Space>

Plug 'junegunn/limelight.vim'
"Plug 'junegunn/vim-emoji'

" Ctrl-P 
" https://github.com/kien/ctrlp.vim
" <c-t> open in new tab
" <c-v> open in vertical split
" <c-s> open in horizontal split
" <c-y> create new file (and its parent dirs)
" <c-z> mark file to be opened, with <c-o>
Plug 'kien/ctrlp.vim'
nnoremap <leader>t :CtrlP<CR>
let g:ctrlp_match_window = 'bottom,order:ttb,min:1,max:15,results:15' " Display options
let g:ctrlp_switch_buffer = '0'       " turn off jump to already open file
let g:ctrlp_root_markers = ['.ctrlp'] " Sets working dir relative to a .git, or a .ctrlp
let g:ctrlp_custom_ignore = { 'dir': 'node_modules\|bower_components\|dist\|build\|coverage' }

" NERDTree
Plug 'scrooloose/nerdtree'
noremap <leader>n<space> :NERDTreeToggle <CR>
noremap <leader>nf :NERDTreeFind<CR>		     
nnoremap <leader>no :NERDTreeFocus<CR>		
let NERDTreeIgnore=[ '\.pyc$', '\.pyo$', '\.py\$class$', '\.obj$',
                    \ '\.o$', '\.so$', '\.egg$', '^\.git$', '\.DS_STORE', 
                    \ '\.svn' ]

let NERDTreeShowFiles=1           " Show hidden files
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=1
let NERDTreeHighlightCursorline=1 " Highlight the selected entry in the tree
let NERDTreeMouseMode=2           " Click to fold directories, double click to open files
let NERDChristmasTree=1           " More colorful
let NERDTreeWinPos=0              " 0 for left aligned, 1 for right

Plug 'scrooloose/nerdcommenter'
Plug 'flazz/vim-colorschemes'
Plug 'godlygeek/tabular'

" Gist
Plug 'mattn/gist-vim'
Plug 'mattn/webapi-vim'
let g:gist_open_browser_after_post = 1

" Syntastic - syntax checking on save
Plug 'scrooloose/syntastic'
let g:syntastic_mode_map={ 'mode': 'active',
                     \ 'active_filetypes': ['coffee'],
                     \ 'passive_filetypes': ['html'] }

" Languages
Plug 'slim-template/vim-slim'
Plug 'kchmck/vim-coffee-script'
Plug 'groenewege/vim-less'
Plug 'digitaltoad/vim-jade'

" Snippets
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'
call plug#end()
"Plug 'file:///Users/mfrawley/dotfiles-1/.vim/snippets'
au! BufWritePost *.snippet call ReloadAllSnippets()

filetype indent plugin on
syntax enable


"
" File Aliases
"
autocmd BufRead,BufNewFile *.{ru,thor} set ft=ruby
autocmd BufRead,BufNewFile *.{esnext} set ft=javascript
"au BufRead,BufNewFile *.{html,aspx,master} set ft=html syntax=html5
"au BufRead,BufNewFile *.{cshtml} set ft=html syntax=cshtml

"
" Settings
"
set modelines=0
set ruler                                    " show position in file   
set number                                   " show line numbers  
set ttyfast                                  " Optimize for fast terminal connections
set encoding=utf-8 nobomb         			" Use UTF-8 without BOM
set history=1000                             " limit :cmdline history   
set noeb vb t_vb=                            " no error bells
set nowrap                                   " no carriage returns
set laststatus=2                             " always show status line.
set tabstop=2                                " number of spaces of tab character
set shiftwidth=2                             " number of spaces to (auto)indent
set smarttab
set nostartofline
set noautowrite                              " don't write on :next
set autoindent                               " auto indents the next new line
set timeoutlen=500                           " shortens the lag time with using leader
set smartindent
set title
set expandtab                                " Turn tabs into spaces
set lz                                       " when macros are running don't redraw
set backspace=start,indent
set virtualedit=all
set backspace=2                              " make backspace work the way it should
set whichwrap+=<,>,h,l                       " make backspace and cursor keys wrap accordingly
set incsearch                                " show the next match while typing 
set gdefault                                 " Add the g flag to search by default
set ignorecase                               " make searches case-insensitive   
set smartcase                                " ...unless they contain capitals
set cursorline                               " turn on line highlighting 
set hlsearch                                 " turn on highlighted search     
set hidden                                   " move to buffer without saving current
set clipboard+=unnamed                       " use system clipboard
set shortmess=atI                            " skip intro message
set backupdir=~/.vim/backups                 " Centralize backups, swapfiles and undo history
"set directory=~/.vim/swaps
set undodir=~/.vim/undo
"set nobackup       
"set nowritebackup  
set noswapfile     

set numberwidth=2                            " set the number width spacing
set dictionary=/usr/share/dict/words         " more words

set statusline=
set statusline+=%2*%-3.3n%0*\                " buffer number
set statusline+=%f\                          " file name
set statusline+=%h%1*%m%r%w%0*               " flags
set statusline+=\[%{strlen(&ft)?&ft:'none'}, " filetype
set statusline+=%{&encoding},                " encoding
set statusline+=%{&fileformat}]              " file format
set statusline+=%=                           " right align
set statusline+=%2*0x%-8B\                   " current char
set statusline+=%-14.(%l,%c%V%)\ %<%P        " offset

set pastetoggle=<F2>
set helpheight=200                           " help windows take up near full window size
set scrolloff=4                              " Keep cursor from edge of screen on scroll
set synmaxcol=2048                           " Don't color lines that are too long
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_         " Show “invisible” characters
set list


" Command Mode
" allow command line editing like the shell
cnoremap <C-A>      <Home>
cnoremap <C-B>      <Left>
cnoremap <C-E>      <End>
cnoremap <C-F>      <Right>
cnoremap <C-N>      <End>
cnoremap <C-P>      <Up>
cnoremap <ESC>b     <S-Left>
cnoremap <ESC><C-B> <S-Left>
cnoremap <ESC>f     <S-Right>
cnoremap <ESC><C-F> <S-Right>
cnoremap <ESC><C-H> <C-W>


"
" GUI Settings
"
if has("gui_running")
  syntax on
  "colorscheme fruity
  "colorscheme lucius
  "colorscheme desertEx
  set guioptions=egmtc 
  set showtabline=2                 "2 enables tabs
  set antialias   
  "set guifont=Inconsolata-dz\ For\ Powerline:h11
  set transp=0      

  " Saving puts you in normal mode
  "iunmenu File.Save 
  "imenu <silent> File.Save <Esc>:if expand("%") == ""<Bar>browse confirm w<Bar>else<Bar>confirm w<Bar>endif<CR>
  
  " Disable command+s - bad habbit
  macmenu &File.Save key=<nop>
  map <D-s> <ESC>

  " Fullscreen takes up entire screen
  set fuoptions=maxhorz,maxvert
  
  " Start without the toolbar
  set guioptions-=T
endif




"
" Keymappings
"

" jk to escape
inoremap jk <Esc>

" Remap delete character to not yank
noremap x "_x
noremap X "_X

" Delete line without yank
map K "_dd

" yank to end of line, like D
map Y y$

" Arrow keys scroll screen
map <Down> <c-e>
map <Up> <c-y>

" Press space to clear search highlighting and any message already displayed.
nnoremap <silent> <Space> :silent noh<Bar>echo<CR>               

" Makes * and # work on visual mode too.
function! s:VSetSearch(cmdtype)
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
  let @s = temp
endfunction
xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

" Use Q for formatting the current paragraph (or selection)
vmap Q gq
nmap Q gqap

" Remap j/k to respect wrapped lines
nnoremap j gj
nnoremap k gk

" https://github.com/junegunn/dotfiles/blob/master/vimrc#L359-L363
" Movement in insert mode
inoremap <C-h> <C-o>h
inoremap <C-l> <C-o>a
inoremap <C-j> <C-o>j
inoremap <C-k> <C-o>k

" ----------------------------------------------------------------------------
" <tab> / <s-tab> | Circular windows navigation
" ----------------------------------------------------------------------------
nnoremap <tab>   <c-w>w
nnoremap <S-tab> <c-w>W


" Easy window navigation
"map <C-h> <C-w>h
"map <C-j> <C-w>j
"map <C-k> <C-w>k
"map <C-l> <C-w>l

" Switch back to last buffer
nmap <silent> <leader>f <C-S-6>

" Remove extra line spaces
nnoremap <silent> <leader>C :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>:retab<CR>

" Edit config files
function! MyConfigurationFiles()
  execute ":e ~/.dotfiles/vim/vimrc.symlink"
  execute ":vsplit ~/.gvimrc"
  execute ":vsplit ~/.dotfiles/"
endfunction
map <leader>e :call MyConfigurationFiles()<CR>

" Source vimrc
nmap <silent> <leader>r :so $MYVIMRC<CR>:so $MYGVIMRC<CR>

" Underline the current line with '='
nmap <silent> ,U :t.\|s/./=/g\|set nohls<cr>

" Recursively vimgrep for word under cursor or selection
nmap <leader>* :execute 'noautocmd vimgrep /\V' . substitute(escape(expand("<cword>"), '\'), '\n', '\\n', 'g') . '/ **'<CR>
vmap <leader>* :<C-u>call <SID>VSetSearch()<CR>:execute 'noautocmd vimgrep /' . @/ . '/ **'<CR>

" Run shell command and insert output in new scratch buffer.  E.g: :R ack icon- html
:command! -nargs=* -complete=shellcmd R new | setlocal buftype=nofile bufhidden=hide noswapfile | r !<args>



" ----------------------------------------------------------------------------
" :Root | Change directory to the root of the Git repository
" ----------------------------------------------------------------------------
function! s:root()
  let me = expand('%:p:h')
  let gitd = finddir('.git', me.';')
  if empty(gitd)
    echo "Not in git repo"
  else
    let gitp = fnamemodify(gitd, ':h')
    echo "Change directory to: ".gitp
    execute 'lcd' gitp
  endif
endfunction
command! Root call s:root()


" add '-' to list of word seperator characters
set iskeyword+=-

