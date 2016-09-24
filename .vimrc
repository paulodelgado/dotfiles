set nocompatible               " be iMproved
set nofoldenable
filetype off                   " required!

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle
" required! 
Plugin 'gmarik/vundle'

" My Bundles here:
" original repos on github
Plugin 'Lokaltog/vim-easymotion'
Plugin 'jgdavey/tslime.vim'
Plugin 'jgdavey/vim-turbux'
Plugin 'kien/ctrlp.vim'
Plugin 'mileszs/ack.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-haml'
Plugin 'tpope/vim-rails.git'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-repeat'
Plugin 'vim-scripts/ZoomWin'
Plugin 'duff/vim-bufonly'
Plugin 'mattn/gist-vim'
Plugin 'mattn/webapi-vim'
Plugin 'nono/vim-handlebars'
Plugin 'altercation/vim-colors-solarized'
Plugin 'tpope/vim-bundler'
Plugin 'kchmck/vim-coffee-script'
Plugin 'scrooloose/syntastic'
Plugin 'heartsentwined/vim-emblem'

" Objective C Development
Plugin 'eraserhd/vim-ios'

call vundle#end()
filetype plugin indent on     " required!

function! HTry(function, ...)
  if exists('*'.a:function)
    return call(a:function, a:000)
  else
    return ''
  endif
endfunction

" Paulo's setup
syntax on
syntax enable
set background=dark
colorscheme solarized
set guifont=Monaco:h14
set guioptions-=T guioptions-=e guioptions-=L guioptions-=r
set shell=bash
set laststatus=2
set statusline=[%n]\ %<%.99f\ %h%w%m%r%{HTry('CapsLockStatusline')}%y%{HTry('rails#statusline')}%{HTry('fugitive#statusline')}%#ErrorMsg#%{HTry('SyntasticStatuslineFlag')}%*%=%-14.(%l,%c%V%)\ %P
set incsearch
set hlsearch
set nu
set wildmenu
set wildmode=list:longest,full
set nowrap
if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif
set list            " show trailing whiteshace and tabs
set smarttab
set shiftwidth=2
set expandtab
set tabstop=2
set autoindent
set softtabstop=2
set backspace=indent,eol,start

let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1
let g:gist_post_private = 1

iabbrev rdebug    require 'ruby-debug'; Debugger.start; Debugger.settings[:autoeval] = 1; Debugger.settings[:autolist] = 1; debugger
iabbrev bpry      require 'pry'; binding.pry

autocmd CursorHold,BufWritePost,BufReadPost,BufLeave *
        \ if isdirectory(expand("<amatch>:h")) | let &swapfile = &modified | endif
au BufRead,BufNewFile *.hamlc set ft=haml
au BufRead,BufNewFile *.rabl setf ruby

map <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
map <Leader>n <plug>NERDTreeTabsToggle<CR>
map zz <Esc>:Zoom<CR>
map <Leader>[ :tabprevious<CR>
map <Leader>] :tabnext<CR>

nnoremap <silent> <C-K> :%s/\s\+$//e<CR><C-K>
nnoremap <leader>. :CtrlPTag<cr>
call togglebg#map("<F5>")

"Rename tabs to show tab# and # of viewports
if exists("+showtabline")
  function! MyTabLine()
    let s = ''
    let wn = ''
    let t = tabpagenr()
    let i = 1
    while i <= tabpagenr('$')
      let buflist = tabpagebuflist(i)
      let winnr = tabpagewinnr(i)
      let s .= '%' . i . 'T'
      let s .= (i == t ? '%1*' : '%2*')
      let s .= ' '
      let wn = tabpagewinnr(i,'$')

      let s .= (i== t ? '%#TabNumSel#' : '%#TabNum#')
      let s .= i
      if tabpagewinnr(i,'$') > 1
        let s .= '.'
        let s .= (i== t ? '%#TabWinNumSel#' : '%#TabWinNum#')
        let s .= (tabpagewinnr(i,'$') > 1 ? wn : '')
      end

      let s .= ' %*'
      let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
      let bufnr = buflist[winnr - 1]
      let file = bufname(bufnr)
      let buftype = getbufvar(bufnr, 'buftype')
      if buftype == 'nofile'
        if file =~ '\/.'
          let file = substitute(file, '.*\/\ze.', '', '')
        endif
      else
        let file = fnamemodify(file, ':p:t')
      endif
      if file == ''
        let file = '[No Name]'
      endif
      let s .= file
      let s .= (i == t ? '%m' : '')
      let i = i + 1
    endwhile
    let s .= '%T%#TabLineFill#%='
    return s
  endfunction
  set stal=2
  set tabline=%!MyTabLine()
endif

set clipboard=unnamed
