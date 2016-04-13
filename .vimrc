""""""""""""""""""""""""""""""""""""""""""""""""""
" General
""""""""""""""""""""""""""""""""""""""""""""""""""

" Set backspace
set backspace=eol,start,indent

" Lines folding
"set foldenable
"set foldnestmax=1
"set foldmethod=syntax

" Turn backup on
set backup

set t_Co=256

set cursorline
" set cursorcolumn

" Set fileencodings
set fileencodings=ucs-bom,utf-8,gbk,big5

" Set complete options
set completeopt=longest,menu

" Set backup directory
set backupdir=$HOME/.vim/backup

" Set swap file directory
set directory=$HOME/.vim/swap,/tmp

" Set non-linewise display
set display=lastline

" Disable VI compatible mode
set nocompatible

" Auto change current directory
" set autochdir
" clipboard
set clipboard=unnamed

" Use absolute paths in sessions
set sessionoptions-=curdir

" Keep more backups for one file
autocmd BufWritePre * let &backupext = strftime(".%m-%d-%H-%M")


""""""""""""""""""""""""""""""""""""""""""""""""""
" Status
""""""""""""""""""""""""""""""""""""""""""""""""""

set laststatus=2

function! CurDir()
	let curdir = substitute(getcwd(), '/Users/amir/', "~/", "g")
	return curdir
endfunction

set statusline=\ %F%m%r%h\ %w\ \ CWD:\ %r%{CurDir()}%h\ \ \ Line:\ %l/%L:%c

""""""""""""""""""""""""""""""""""""""""""""""""""
" Colors
""""""""""""""""""""""""""""""""""""""""""""""""""

" Set colorscheme
colorscheme desert
" colorscheme lilypink
" colorscheme molokai

" Enable syntax highlight
syntax on

""""""""""""""""""""""""""""""""""""""""""""""""""
" Interface
""""""""""""""""""""""""""""""""""""""""""""""""""

" Show ruler
set ruler

" Dynamic title
set title

" Turn on Wild menu
set wildmenu

" Display line number
" set number

""""""""""""""""""""""""""""""""""""""""""""""""""
" Search
""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable magic matching
set magic

" Show matching bracets
set showmatch

" Highlight search things
set hlsearch

" Ignore case when searching
set smartcase
set ignorecase

" Incremental match when searching
set incsearch

""""""""""""""""""""""""""""""""""""""""""""""""""
" Indent
""""""""""""""""""""""""""""""""""""""""""""""""""

" Auto indent
set autoindent

" Smart indet
set smartindent

" Use hard tabs
set tabstop=8
set noexpandtab
set shiftwidth=8

" Break long lines
"set textwidth=78

" Set auto-formating
set formatoptions+=mM

" Config C-indenting
set cinoptions=:0,l1,t0,g0

" Enable filetype plugin
filetype plugin indent on

" set textwidth for mail
autocmd FileType mail set textwidth=72

" Use soft tabs for python
autocmd FileType python set et sta ts=4 sw=4

""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""

" Use my own cscope mappings
let autocscope_menus=0

" Auto change the root directory
let NERDTreeChDirMode=2

""""""""""""""""""""""""""""""""""""""""""""""""""
" CTags
""""""""""""""""""""""""""""""""""""""""""""""""""

" Auto finding
set tags=tags;

" Sort by name
let Tlist_Sort_Type="name"

" Use right window
let Tlist_Use_Right_Window=1

" Enable auto update
let Tlist_Auto_Update=1

" Set compart format
let Tlist_Compart_Format=1

" Set exit by window
let Tlist_Exit_OnlyWindow=1

" Disable fold column
let Tlist_Enable_Fold_Column=0

""""""""""""""""""""""""""""""""""""""""""""""""""
" Cscope
""""""""""""""""""""""""""""""""""""""""""""""""""

" Use both cscope and ctag
" set cscopetag

" Show msg when cscope db added
" set cscopeverbose

" Use tags for definition search first
" set cscopetagorder=1

" Use quickfix window to show cscope results
" set cscopequickfix=s-,g-,d-,c-,t-,e-,f-,i-

""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""

" Tab navigation
nnoremap tp :tabprevious<CR>
nnoremap tn :tabnext<CR>
nnoremap to :tabnew<CR>
nnoremap te :tabedit<CR>
nnoremap tc :tabclose<CR>
nnoremap bb :CtrlPBuffer<CR>
nnoremap gf <C-W>gf

" Conque plugin
nnoremap tt :ConqueTermVSplit bash<CR>

" Move among windows
noremap <C-h> <C-W>h
noremap <C-l> <C-W>l
noremap <C-j> <C-W>j
noremap <C-k> <C-W>k
noremap <C-n> <C-W>n

map mm :tabedit 

nnoremap vv :vsplit<CR>
nnoremap ss :split<CR>
nnoremap fs :Sexplore!<CR>
nnoremap vn :vertical new<CR> map <C-m> :tabedit 

" Cscope mappings
" nnoremap <C-w>\ :scs find c <C-R>=expand("<cword>")<CR><CR>
" nnoremap <C-\>s :scs find s <C-R>=expand("<cword>")<CR><CR>
" nnoremap <C-\>g :scs find g <C-R>=expand("<cword>")<CR><CR>
" nnoremap <C-\>d :scs find d <C-R>=expand("<cword>")<CR><CR>
" nnoremap <C-\>c :scs find c <C-R>=expand("<cword>")<CR><CR>
" nnoremap <C-\>t :scs find t <C-R>=expand("<cword>")<CR><CR>
" nnoremap <C-\>e :scs find e <C-R>=expand("<cword>")<CR><CR>
" nnoremap <C-\>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
" nnoremap <C-\>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
map <F12> :q!<CR>
map <F2> :cs find g <C-R>=expand("<cword>")<CR><CR>
map <F3> :scs find g <C-R>=expand("<cword>")<CR><CR>
map <F4> :scs find s <C-R>=expand("<cword>")<CR><CR>
map <F5> :cs find c <C-R>=expand("<cword>")<CR><CR>
map <F6> :cs find t <C-R>=expand("<cword>")<CR><CR>
map <F7> :cs find e <C-R>=expand("<cword>")<CR><CR>
map <F8> :cs find f <C-R>=expand("<cfile>")<CR><CR>

" Set Up and Down non-linewise
noremap <Up> gk
noremap <Down> gj

" Toggle Tlist
nnoremap <silent> <F6> :TlistToggle<CR>:TlistUpdate<CR>

" Grep search tools
" nnoremap <F9> :Rgrep<CR>

" Paste toggle
"set pastetoggle=<F4>

" Save & Make 
" nnoremap <F10> :w<CR>:make!<CR>
" nnoremap <F9> :w<CR>:make! %< CC=gcc CFLAGS="-Wall -g -O2 -pthread -lrt"<CR>:!./%<<CR>
nnoremap <F9> :w<CR>:make! %< CC=gcc CFLAGS="-Wall -g -O2 -pthread -lrt"<CR>
 
" Quickfix window
nnoremap <silent> <F7> :botright copen<CR>
nnoremap <silent> <F8> :cclose<CR>

" autocmd QuickFixCmdPost [^l]* nested copen
autocmd QuickFixCmdPost [^l]* nested cwindow 
autocmd QuickFixCmdPost    l* nested lwindow 

" NERDTreeToggle
nnoremap <silent> <F5> :NERDTreeToggle<CR>

" Toggle display line number
nnoremap <silent> <F11> :set number!<CR>
nnoremap <silent> <F10> :set relativenumber!<CR>
" nnoremap <silent> <F9> :set cursorcolumn!<CR>
" nnoremap <F10> :NumbersToggle<CR>

" Use <space> to toggle fold
nnoremap <silent> <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

" Use xsel to access the X clipboard
if $DISPLAY != '' && executable('xsel')
	nnoremap <silent> "*y :'[,']w !xsel -i -p -l /dev/null<CR>
	nnoremap <silent> ch :'[,']w !xsel -i -p -l /dev/null<CR>
	nnoremap <silent> "*p :r!xsel -p<CR>
	nnoremap <silent> cl :r!xsel -p<CR>
	nnoremap <silent> "+y :'[,']w !xsel -i -b -l /dev/null<CR>
	nnoremap <silent> cj :'[,']w !xsel -i -b -l /dev/null<CR>
	nnoremap <silent> "+p :r!xsel -b<CR>
	nnoremap <silent> ck :r!xsel -b<CR>
endif

" Google translate
" nmap <silent> <F11> :echo Google_Translate('en','zh-CN',expand('<cword>'))<CR>
" nmap <silent> <F11> :echo GoogleTranslator('en','zh-CN',expand('<cword>'))<CR>

" vim regress
let VIMPRESS = [{'username':'zhudong',
                \'blog_url':'http://www.bluezd.info'
                \}]
" Powerline
" let g:Powerline_symbols = 'fancy'

" EasyMotion
let g:EasyMotion_leader_key = '<Leader>'

" vim movement
nnoremap <PageUp>  mz:m-2<cr>`z==
nnoremap <PageDown>  mz:m+<cr>`z==
xnoremap <PageUp>  :m'<-2<cr>gv=gv
xnoremap <PageDown>  :m'>+<cr>gv=gv

  " add empty line
noremap <silent> sl O<ESC>jo<ESC>k

" Vundle
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'Lokaltog/vim-powerline'
Plugin 'Lokaltog/vim-easymotion' 
" Plugin 'Markdown'
Plugin 'VimRepress'
Plugin 'Google-Translate'
"Plugin 'hallison/vim-markdown' 
"Plugin 'tpope/vim-markdown' 

" Markdown
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'

Plugin 'fcitx.vim'
Plugin 'Align'
Plugin 'autoload_cscope.vim'
Plugin 'bufexplorer.zip'
Plugin 'ctrlp.vim'
Plugin 'DrawIt'
Plugin 'grep.vim'
Plugin 'Indent-Guides'
Plugin 'matchit.zip'
Plugin 'snipMate'
Plugin 'Tagbar'
Plugin 'The-NERD-tree'
"Plugin "myusuf3/numbers.vim"
Plugin 'calendar.vim'
"Plugin 'Indent-Guides'

Plugin 'vim-gitgutter'
"Plugin 'vim-linemovement'

Plugin 'vimwiki'

call vundle#end()
filetype plugin indent on
