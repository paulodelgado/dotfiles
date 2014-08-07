set nocompatible               " be iMproved
set nofoldenable
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

" My Bundles here:
" original repos on github
Bundle 'Lokaltog/vim-easymotion'
Bundle 'jgdavey/tslime.vim'
Bundle 'jgdavey/vim-turbux'
Bundle 'kien/ctrlp.vim'
Bundle 'mileszs/ack.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-haml'
Bundle 'tpope/vim-rails.git'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-unimpaired'
Bundle 'tpope/vim-vividchalk'
Bundle 'tpope/vim-repeat'
Bundle 'tsaleh/vim-matchit'
Bundle 'vim-scripts/ZoomWin'
Bundle 'duff/vim-bufonly'
Bundle 'mattn/gist-vim'
Bundle 'mattn/webapi-vim'
Bundle 'nono/vim-handlebars'
Bundle 'altercation/vim-colors-solarized'
" Bundle 'myusuf3/numbers.vim'
Bundle 'tpope/vim-bundler'
Bundle 'airblade/vim-gitgutter'
Bundle 'kchmck/vim-coffee-script'
Bundle 'scrooloose/syntastic'
Bundle 'heartsentwined/vim-emblem'

" Objective C Development
Bundle 'eraserhd/vim-ios'

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

map <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
map zz <Esc>:Zoom<CR>
map <Leader>[ :tabprevious<CR>
map <Leader>] :tabnext<CR>

nnoremap <silent> <C-K> :%s/\s\+$//e<CR><C-K>
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
