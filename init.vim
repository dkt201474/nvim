
"-----------------------------------------------------------------------
"
"- NVIM Base file
"- Author : dkt201474
"- Date : 28/12/2016
"- Version : 1.0
"
"-----------------------------------------------------------------------

"------------Install and Run Plugin manager (Plug vim)---------------"
set nocompatible               " Be iMproved

let vimplug_exists=expand('~/.config/nvim/autoload/plug.vim')

if !filereadable(vimplug_exists)
  echo "Installing Vim-Plug..."
  echo ""
  silent !\curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let g:not_finish_vimplug = "yes"
  autocmd VimEnter * PlugInstall
endif

" Required:
call plug#begin(expand('~/.config/nvim/plugged'))

"------------Install Basic Bundles------------------------------------"
if filereadable(expand("~/.config/nvim/nvim-plugins.vim"))
    source ~/.config/nvim/nvim-plugins.vim
endif

"------------Install Custom Bundles-----------------------------------"
if filereadable(expand("~/.config/nvim/nvim.plugins.local.vim"))
  source ~/.config/nvim/nvim.plugins.local.vim"
endif

call plug#end()

"------------Basic setup----------------------------------------------"
filetype plugin indent on

"Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8

"Fix backspace indent
set backspace=indent,eol,start

"Tabs. May be overriten by autocmd rules
set tabstop=4
set softtabstop=0
set shiftwidth=4
set expandtab

"Map leader to ,
let mapleader=','

"subtitute
set gdefault        "replace all occurence with the parameter setted

"Enable hidden buffers
set hidden

"Searching
set hlsearch
set incsearch
set ignorecase
set smartcase
set path+=**
set wildmenu

"autocomplete
set complete=.,w,b,u

"Directories for swp files
set nobackup
set noswapfile

" Disable visualbell
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif

set showcmd
set shell=/bin/sh

"------------Visuals settings------------------------------------"
syntax on
set ruler
set linebreak       " don't wrap in the middle of a word
set showbreak=>\    " stylize line breaked with > and space
set relativenumber  " to jump more quickly
set textwidth=79    " start wrapping after 79 characters
set scrolloff=10    " start scrolling 10 before the end
set background=dark
set showtabline=0
set helpheight=40
set mouse+=a
set background=dark

"" Disable the blinking cursor.
set gcr=n:blinkon0

"status bar
set laststatus=2  "always show the status bar
set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\

"title
set title
set titlestring=%F

"------------Plugins settings------------------------------------"
if filereadable(expand("~/.config/nvim/nvim-plugins-configs.vim"))
  source ~/.config/nvim/nvim-plugins-configs.vim
endif

"------------Custom settings-------------------------------------"

"" Include additionl local vim config
if filereadable(expand("~/.config/nvim/nvim-local-config.vim"))
  source ~/.config/nvim/nvim-local-config.vim
endif

"------------Abbreviation---------------------------------------"
"" live saver
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

"open configs files
cnoreabbrev vimrc tabe ~/.config/nvim/init.vim
cnoreabbrev vimp tabe ~/.config/nvim/nvim-plugins.vim
cnoreabbrev vimpc tabe ~/.config/nvim/nvim-plugins-configs.vim
cnoreabbrev vimlc tabe ~/.config/nvim/nvim-local-config.vim
cnoreabbrev tips tabe ~/.config/nvim/nvim-tips.vim


"------------AUTOCMD RULES------------------------------------------------"
"Automatically source the vimrc file after on save
autocmd BufWritePost init.vim source %

"The PC is fast enough, do syntax highlight syncing from start
augroup vimrc-sync-fromstart
  autocmd!
  autocmd Vimenter * set showtabline=0
  autocmd BufEnter * :syntax sync fromstart
augroup END

"Remember cursor position
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

"txt
augroup vimrc-wrapping
  autocmd!
  autocmd BufRead,BufNewFile *.txt call s:setupWrapping()
augroup END


"------------Mappings------------------------------------------------------"
"jk to go to normal mode
inoremap jk <esc>

"Disable arrow keys
noremap <left> <nop>
noremap <right> <nop>
noremap <up> <nop>
noremap <down> <nop>

"Object remaping
onoremap ( i(
onoremap { i{
onoremap " i"
onoremap t it
onoremap ' i'

"nav : no difference between wrap lines and screen lines when moving in the file
nnoremap j gj
nnoremap 0 g0

"Searching : Fix regular expression problems
" nnoremap / /\v
" vnoremap / /\v
" nnoremap ? ?\v
" vnoremap ? ?\v

"Split
noremap <leader>h :<C-u>split<cr>
noremap <leader>v :<C-u>vsplit<cr>

"" Git
noremap <Leader>ga :Gwrite<CR>
noremap <Leader>gc :Gcommit<CR>
noremap <Leader>gsh :!git push -u origin master<CR>
noremap <Leader>gll :Gpull<CR>
noremap <Leader>gs :Gstatus<CR>
noremap <Leader>gb :Gblame<CR>
noremap <Leader>gd :Gvdiff<CR>
noremap <Leader>gr :Gremove<CR>

"" Open current line on GitHub
nnoremap <Leader>o :.Gbrowse<CR>

"Buffer nav
noremap <leader>q :bp<CR>
noremap <leader>w :bn<CR>

"" Switching windows
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

"save/exit buffer 
nnoremap <leader>s :w!<CR>
nnoremap <leader>x :q<cr>

"macro trigger set to ,.
nnoremap <leader>. @q

"clean search (highlight)
nnoremap <silent> <leader><space> :noh<cr>

"Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

"move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

"------------Functions-----------------------------------------"
"" For wrapping the text width
if !exists('*s:setupWrapping')
  function s:setupWrapping()
      set wrap
      set wm=2
      set textwidth=79
  endfunction
endif


